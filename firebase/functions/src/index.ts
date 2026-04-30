import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions/v1';
import { geohashQueryBounds, distanceBetween } from 'geofire-common';

admin.initializeApp();

const db = admin.firestore();

type City = 'asyut' | 'sohag' | 'qena';

function assertAllowedCity(city: string): asserts city is City {
  if (!['asyut', 'sohag', 'qena'].includes(city)) {
    throw new functions.https.HttpsError('invalid-argument', 'city_not_allowed');
  }
}

export const handleTripRequest = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'auth_required');
  }

  const { tripId } = data as { tripId?: string };
  if (!tripId) {
    throw new functions.https.HttpsError('invalid-argument', 'tripId_required');
  }

  const tripRef = db.collection('trips').doc(tripId);
  const tripSnap = await tripRef.get();
  if (!tripSnap.exists) {
    throw new functions.https.HttpsError('not-found', 'trip_not_found');
  }

  const trip = tripSnap.data()!;
  const city = String(trip.city ?? '');
  assertAllowedCity(city);

  const pickup = trip.pickup;
  const lat = Number(pickup?.lat);
  const lng = Number(pickup?.lng);
  if (!Number.isFinite(lat) || !Number.isFinite(lng)) {
    throw new functions.https.HttpsError('invalid-argument', 'pickup_required');
  }

  // Find nearest driver within 5km using geohash bounds.
  const center: [number, number] = [lat, lng];
  const radiusInM = 5000;
  const bounds = geohashQueryBounds(center, radiusInM);

  const candidates: Array<{ id: string; distanceKm: number }> = [];
  for (const b of bounds) {
    const q = db
      .collection('drivers')
      .where('city', '==', city)
      .where('isOnline', '==', true)
      .where('isApproved', '==', true)
      .orderBy('geohash')
      .startAt(b[0])
      .endAt(b[1])
      .limit(50);
    const snap = await q.get();
    snap.docs.forEach((d) => {
      const dd = d.data() as any;
      const gp = dd.currentLocation;
      if (!gp) return;
      const dKm = distanceBetween(center, [gp.latitude, gp.longitude]);
      if (dKm <= radiusInM / 1000) candidates.push({ id: d.id, distanceKm: dKm });
    });
  }

  candidates.sort((a, b) => a.distanceKm - b.distanceKm);
  const chosen = candidates[0]?.id ?? null;

  if (!chosen) {
    await tripRef.update({ status: 'no_driver' });
    return { ok: false, reason: 'no_driver' };
  }

  await tripRef.update({ driverId: chosen, status: 'accepted' });
  return { ok: true, driverId: chosen };
});

export const calculateFinalFare = functions.firestore
  .document('trips/{tripId}')
  .onUpdate(async (change: functions.Change<functions.firestore.DocumentSnapshot>) => {
    const after = change.after.data();
    const before = change.before.data();
    if (!after || !before) return;

    if (before.status === 'completed' || after.status !== 'completed') return;

    const driverId = after.driverId as string | undefined;
    if (!driverId) return;

    const total = Number(after.fareBreakdown?.total ?? 0);
    const commission = total * 0.2;
    const driverShare = total - commission;

    const walletRef = db.collection('wallets').doc(driverId);
    await db.runTransaction(async (tx) => {
      const w = await tx.get(walletRef);
      const prev = w.exists ? Number(w.data()!.balance ?? 0) : 0;
      const next = prev + driverShare - commission;
      tx.set(
        walletRef,
        {
          balance: next,
          updatedAt: admin.firestore.FieldValue.serverTimestamp()
        },
        { merge: true }
      );
    });
  });

export const walletGuard = functions.firestore
  .document('wallets/{driverId}')
  .onWrite(
    async (
      change: functions.Change<functions.firestore.DocumentSnapshot>,
      context: functions.EventContext,
    ) => {
      const driverId = context.params.driverId as string;
    const data = change.after.exists ? change.after.data() : null;
    if (!data) return;

    const balance = Number((data as any).balance ?? 0);
    const isBlocked = balance <= -100;

    await db.collection('drivers').doc(driverId).set({ isBlocked }, { merge: true });
    },
  );

export const processPayment = functions.https.onRequest(async (req, res) => {
  // Vodafone Cash + InstaPay adapters will be integrated here.
  // For now, this is a test stub endpoint.
  res.status(200).json({ ok: true });
});


## Firestore schema (initial)

This is the authoritative schema for MVP + v1. Field additions should remain backward compatible.

### `users/{uid}`
- `role`: `'passenger'`
- `name`: string
- `phone`: string
- `city`: `'asyut' | 'sohag' | 'qena'`
- `rating`: number
- `totalTrips`: number
- `savedPlaces`: array of `{ name, lat, lng }`
- `createdAt`: timestamp

### `drivers/{uid}`
- `role`: `'driver'`
- `name`, `phone`, `city`
- `carModel`, `carColor`, `plateNumber`
- `rating`, `totalTrips`
- `isOnline`: bool
- `isApproved`: bool
- `isBlocked`: bool
- `currentLocation`: geopoint
- `updatedAt`: timestamp

### `trips/{tripId}`
- `passengerId`, `driverId`, `city`
- `pickup`: `{ name, lat, lng }`
- `dropoff`: `{ name, lat, lng }`
- `rideType`: `'x' | 'comfort'`
- `status`: `searching | accepted | arriving | inProgress | completed | cancelled | no_driver`
- `distanceKm`, `durationMinutes`
- `fareBreakdown`: `{ base, distanceFare, timeFare, surgeMult, serviceFee, total }`
- `payment_method`: `cash | vodafone_cash | instapay`
- `payment_status`: `pending | completed | failed`
- `payment_reference`: string
- `createdAt`, `startedAt`, `completedAt`

### `config/pricing`
- per-city pricing values
- surge window + manual override

### `chats/{tripId}/messages/{messageId}`
- `senderId`, `receiverId`
- `text`
- `sentAt`
- `readAt` (optional)

### `sos/{tripId}`
- `tripId`, `passengerId`, `driverId`, `city`
- `status`: `open | ack | resolved`
- `createdAt`, `ackAt`, `resolvedAt`


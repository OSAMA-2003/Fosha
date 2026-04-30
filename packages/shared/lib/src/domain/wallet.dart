class WalletPolicy {
  static const double commissionRate = 0.20; // Fasha 20%
  static const double driverShareRate = 0.80;
  static const double debtLimitEgp = -100.0;

  static double commissionOf(double fareTotal) => fareTotal * commissionRate;
  static double driverShareOf(double fareTotal) => fareTotal * driverShareRate;

  static bool isBlocked(double walletBalance) => walletBalance <= debtLimitEgp;
}


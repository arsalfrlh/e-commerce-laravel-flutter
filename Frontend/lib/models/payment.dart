class Payment {
  final int id;
  final int beliID;
  final String transaksiID;
  final int? orderID;
  final String? paymentType;
  final String merchantID;
  final String? amount;
  final DateTime transactionTime;
  final DateTime expired;
  final DateTime? paidTime;
  final String? status;
  final String? paymentCode;
  final String? qrCode;
  final String? bank;
  final String? store;

  Payment(
      {required this.id,
      required this.beliID,
      required this.transaksiID,
      this.orderID,
      this.paymentType,
      required this.merchantID,
      this.amount,
      required this.transactionTime,
      required this.expired,
      this.paidTime,
      this.status,
      this.paymentCode,
      this.bank,
      this.qrCode,
      this.store});
}

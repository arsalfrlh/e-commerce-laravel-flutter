class Beli {
  final int id;
  final int? userID;
  final int? barangID;
  final int? paymentID;
  final DateTime? tanggalBeli;
  final int jumlah;
  final int? total;
  final String? status;
  final String? namaBarang;
  final String? gambar;
  final String? name;
  final String paymentType;
  final String? bank;
  final String? store;
  final String? qrCode;
  final String? paymentCode;
  final String? transaksiID;
  final DateTime? expire;

  Beli({required this.id, this.userID, this.barangID, this.paymentID, this.tanggalBeli, required this.jumlah, this.total, this.status, this.namaBarang, this.gambar, this.name, required this.paymentType, this.bank, this.store, this.qrCode, this.paymentCode, this.transaksiID, this.expire});
  factory Beli.fromJson(Map<String, dynamic> json){
    return Beli(
      id: json['id'],
      userID: json['id_user'],
      barangID: json['id_barang'],
      paymentID: json['payment']['id'],
      tanggalBeli: DateTime.parse(json['tanggal_beli']),
      jumlah: json['jumlah'],
      total: json['total'],
      status: json['status'],
      namaBarang: json['barang']['nama_barang'],
      gambar: json['barang']['gambar'],
      name: json['user']['name'],
      paymentType: json['payment']['payment_type'],
      bank: json['payment']['bank'],
      store: json['payment']['store'],
      qrCode: json['payment']['qr_code'],
      paymentCode: json['payment']['payment_code'],
      transaksiID: json['payment']['transaction_id'],
      expire: DateTime.parse(json['payment']['expiry_time']),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'id_barang': barangID,
      'jumlah': jumlah,
      'payment_type': paymentType,
      'bank': bank,
      'store': store,
    };
  }
}

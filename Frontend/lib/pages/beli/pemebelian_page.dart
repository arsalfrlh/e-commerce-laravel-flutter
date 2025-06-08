import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latihan/models/beli.dart';
import 'package:latihan/models/payment.dart';
import 'package:latihan/pages/payment/bank_page.dart';
import 'package:latihan/pages/payment/cstore_page.dart';
import 'package:latihan/pages/payment/gopay_page.dart';
import 'package:latihan/pages/status/cancel_page.dart';
import 'package:latihan/pages/status/expire_page.dart';
import 'package:latihan/pages/status/success_page.dart';
import 'package:latihan/services/api_service.dart';

class PemebelianPage extends StatefulWidget {
  @override
  _PemebelianPageState createState() => _PemebelianPageState();
}

class _PemebelianPageState extends State<PemebelianPage> {
  final ApiService apiService = ApiService();
  List<Beli> beliList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBeli();
  }

  Future<void> fetchBeli() async {
    setState(() {
      isLoading = true;
    });
    beliList = await apiService.getAllBeli();
    setState(() {
      isLoading = false;
    });
  }

  void _cekStatus(BuildContext context, Beli beli)async{
    if(beli.transaksiID != null){
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(),));

      final response = await apiService.cekStatus(beli.transaksiID!);
      Navigator.of(context, rootNavigator: true).pop();

      if(response['success'] == true){
        if(response['data']['transaction_status'] == 'settlement'){
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Pembayaran Berhasil',
            desc: 'Terimakasi pembayaran anda telah berhasil',
            btnOkOnPress: (){
              fetchBeli();
            },
            btnOkColor: Colors.green,
          ).show();
        }else if(response['data']['transaction_status'] == 'cancel'){
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: 'Pembayaran Dibatalkan',
            desc: 'Pembayaran anda telah dibatalkan',
            btnOkOnPress: (){
              fetchBeli();
            },
            btnOkColor: Colors.red,
          ).show();
        }else if(response['data']['transaction_status'] == 'expire'){
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: 'Pembayaran Kadaluarsa',
            desc: 'Pembayaran anda telah Kadaluarsa',
            btnOkOnPress: (){
              fetchBeli();
            },
            btnOkColor: Colors.red,
          ).show();
        }else if(response['data']['transaction_status'] == 'pending'){ //payment bank
          if(response['data']['payment_type'] == 'bank_transfer'){
            final payment = Payment(
              id: beli.paymentID!,
              beliID: beli.id,
              transaksiID: response['data']['transaction_id'],
              merchantID: response['data']['merchant_id'],
              transactionTime: DateTime.parse(response['data']['transaction_time']),
              expired: DateTime.parse(response['data']['expiry_time']),
              bank: response['data']['va_numbers'][0]['bank'],
              paymentCode: response['data']['va_numbers'][0]['va_number'],
            );
            Navigator.push(context, MaterialPageRoute(builder: (context) => BankPage(payment: payment, beli: beli)));
          }else if(response['data']['payment_type'] == 'cstore'){ //payment cstore
            final payment = Payment(
              id: beli.paymentID!,
              beliID: beli.id,
              transaksiID: response['data']['transaction_id'],
              merchantID: response['data']['merchant_id'],
              transactionTime: DateTime.parse(response['data']['transaction_time']),
              expired: DateTime.parse(response['data']['expiry_time']),
              store: response['data']['store'],
              paymentCode: response['data']['payment_code'],
            );
            Navigator.push(context, MaterialPageRoute(builder: (context) => CstorePage(payment: payment, beli: beli)));
          }else if(response['data']['payment_type'] == 'gopay'){ //payment gopay
            final payment = Payment(
              id: beli.paymentID!,
              beliID: beli.id,
              transaksiID: response['data']['transaction_id'],
              merchantID: response['data']['merchant_id'],
              transactionTime: DateTime.parse(response['data']['transaction_time']),
              expired: DateTime.parse(response['data']['expiry_time']),
              qrCode: beli.qrCode,
            );
            Navigator.push(context, MaterialPageRoute(builder: (context) => GopayPage(payment: payment, beli: beli)));
          }
        }else{
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            title: 'Error',
            desc: 'Transaksi tidak ditemukan',
            btnOkOnPress: (){},
            btnOkColor: Colors.red,
          ).show();
        }
      }else{
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.scale,
          title: 'Error',
          desc: response['message'],
          btnOkOnPress: (){},
          btnOkColor: Colors.red,
        ).show();
      }
    }else{
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Error',
        desc: 'Transaksi tidak ditemukan',
        btnOkOnPress: (){},
        btnOkColor: Colors.red,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Daftar Pembelian"),
        backgroundColor: Color(0xFFFF7643),
      ),
      body: RefreshIndicator(
        onRefresh: fetchBeli,
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: beliList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) => ProductCard(
              beli: beliList[index],
              onPress: () => _cekStatus(context, beliList[index]),
            ),
          ),
        ),
      ),
      )
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.beli,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRetio;
  final Beli beli;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CachedNetworkImage(imageUrl: 'http://10.0.2.2:8000/images/${beli.gambar}', fit: BoxFit.cover, errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 120,),)
              ),
            ),
            const SizedBox(height: 8),
            Text(
              beli.namaBarang!,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${beli.total}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF7643),
                  ),
                ),
                Row(
                  children: [
                    if(beli.status == 'paid')
                    Text(
                      "Dibayar",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        backgroundColor: Colors.green,
                      ),
                    ),
                    if(beli.status == 'unpaid')
                    Text(
                      "Menunggu Pembayaran",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        backgroundColor: Colors.orange,
                      ),
                    ),
                    if(beli.status == 'expired')
                    Text(
                      "Kadaluarsa",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        backgroundColor: Colors.red,
                      ),
                    ),
                    if(beli.status == 'cancel')
                    Text(
                      "Dibatalkan",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";

const heartIcon =
    '''<svg width="18" height="16" viewBox="0 0 18 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M16.5266 8.61383L9.27142 15.8877C9.12207 16.0374 8.87889 16.0374 8.72858 15.8877L1.47343 8.61383C0.523696 7.66069 0 6.39366 0 5.04505C0 3.69644 0.523696 2.42942 1.47343 1.47627C2.45572 0.492411 3.74438 0 5.03399 0C6.3236 0 7.61225 0.492411 8.59454 1.47627C8.81857 1.70088 9.18143 1.70088 9.40641 1.47627C11.3691 -0.491451 14.5629 -0.491451 16.5266 1.47627C17.4763 2.42846 18 3.69548 18 5.04505C18 6.39366 17.4763 7.66165 16.5266 8.61383Z" fill="#DBDEE4"/>
</svg>
''';

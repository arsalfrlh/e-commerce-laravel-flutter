import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latihan/models/barang.dart';
import 'package:latihan/pages/barang/update_page.dart';
import 'package:latihan/pages/beli/beli_page.dart';
import 'package:latihan/services/api_service.dart';

class SearchPage extends StatefulWidget {
  SearchPage({required this.cari});
  String cari;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ApiService apiService = ApiService();
  bool isLoading = false;
  List<Barang> seachList = [];

  @override
  void initState() {
    super.initState();
    fetchSearch();
  }

  Future<void> fetchSearch() async {
    setState(() {
      isLoading = true;
    });
    seachList = await apiService.searchBarang(widget.cari);
    setState(() {
      isLoading = false;
    });
  }

  void _delete(BuildContext context, int id){
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      title: 'Hapus Barang',
      desc: 'Apakah Anda yakin?',
      btnOkOnPress: ()async{
        await apiService.deleteBarang(id).then((_) => fetchSearch());
      },
      btnOkColor: Colors.red,
      btnCancelOnPress: (){},
      btnCancelColor: Colors.green,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7643),
        title: const Text("Search Page"),
      ),
      body: RefreshIndicator(
        onRefresh: fetchSearch,
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: seachList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (context, index) => ProductCard(
              barang: seachList[index],
              onPress: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BeliPage(barang: seachList[index]))).then((_) => fetchSearch());
              },
              onUpdate: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdatePage(barang: seachList[index]))).then((_) => fetchSearch());
              },
              onDelete: () => _delete(context, seachList[index].id),
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
    required this.barang,
    required this.onPress,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  final double width, aspectRetio;
  final Barang barang;
  final VoidCallback onPress, onUpdate, onDelete;

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
                  color: const Color(0xFF979797).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CachedNetworkImage(imageUrl: 'http://10.0.2.2:8000/images/${barang.gambar}', fit: BoxFit.cover, errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 120,),),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              barang.namaBarang,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Harga: ${barang.harga}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF7643),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: onUpdate, icon: Icon(Icons.edit)),
                    IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
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

import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latihan/models/barang.dart';
import 'package:latihan/services/api_service.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  _TambahPageState createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final ApiService apiService = ApiService();
  final nmBarangController = TextEditingController();
  final stokController = TextEditingController();
  final hargaController = TextEditingController();
  XFile? gambar;

  void pilih()async{
    gambar = await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  void _tambah(BuildContext context)async{
    if(nmBarangController.text.isNotEmpty && stokController.text.isNotEmpty && hargaController.text.isNotEmpty && gambar != null){
      showDialog(context: context, 
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(),));

    final newBarang = Barang(
      id: 0,
      namaBarang: nmBarangController.text,
      stok: int.parse(stokController.text),
      harga: int.parse(hargaController.text),
    );
    final response = await apiService.addBarang(newBarang, gambar!);
    Navigator.of(context, rootNavigator: true).pop();
    if(response['success'] == true){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        dismissOnTouchOutside: false,
        title: 'Sukses',
        desc: response['message'],
        btnOkOnPress: (){
          Navigator.pop(context);
        },
      ).show();
    }else{
      if(response['data'] != null){
        AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        dismissOnTouchOutside: false,
        title: response['message'],
        desc: response['data'].toString(),
        btnOkOnPress: (){},
      ).show();
      }else{
        AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        dismissOnTouchOutside: false,
        title: 'Error',
        desc: response['message'],
        btnOkOnPress: (){},
      ).show();
      }
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFFFF7643),
        foregroundColor: Colors.white,
        title: const Text("Tambah Barang"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ProfilePic(
              imageUploadBtnPress: pilih,
            ),
            const Divider(),
            Form(
              child: Column(
                children: [
                  UserInfoEditField(
                    text: "Nama Barang",
                    child: TextFormField(
                      controller: nmBarangController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Stok",
                    child: TextFormField(
                      controller: stokController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Harga",
                    child: TextFormField(
                      controller: hargaController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.08),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7643),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () => _tambah(context),
                    child: const Text("Tambah"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.imageUploadBtnPress,
  });

  final VoidCallback imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Icon(Icons.broken_image, size: 120,),
          InkWell(
            onTap: imageUploadBtnPress,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(text),
          ),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}

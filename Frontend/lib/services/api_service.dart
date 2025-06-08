import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:latihan/models/barang.dart';
import 'package:latihan/models/beli.dart';
import 'package:latihan/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> register(String name, String email, String password)async{
    final response = await http.post(Uri.parse('$baseUrl/register'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': name,
      'email': email,
      'password': password,
    })
    );
    return json.decode(response.body);
  }

  Future<User?> getUser() async {
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.get(Uri.parse('$baseUrl/user'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<void> logout()async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    await http.post(Uri.parse('$baseUrl/logout'),
    headers: {'Authorization': 'Bearer $token'});
    await key.remove('token');
    await key.remove('statusLogin');
  }

  Future<List<Barang>> getAllBarang()async{
    final key = await SharedPreferences.getInstance();
    final token =key.getString('token');

    final response = await http.get(Uri.parse('$baseUrl/barang'),
    headers: {'Authorization': 'Bearer $token'});
    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Barang.fromJson(item)).toList();
    }else{
      throw Exception('Data gagal dimuat');
    }
  }

  Future<Map<String, dynamic>> addBarang(Barang barang, XFile gambar)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/barang/tambah'));
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.fields['nama_barang'] = barang.namaBarang;
    request.fields['stok'] = barang.stok.toString();
    request.fields['harga'] = barang.harga.toString();
    request.files.add(await http.MultipartFile.fromPath('gambar', gambar.path));

    final response = await request.send();
    if(response.statusCode == 200){
      final responseData = await http.Response.fromStream(response);
      return json.decode(responseData.body);
    }else{
      throw Exception('Data gagal dikirim');
    }
  }

  Future<Map<String, dynamic>> updateBarang(Barang barang, XFile? gambar)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/barang/update'));
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.fields['id'] = barang.id.toString();
    request.fields['nama_barang'] = barang.namaBarang;
    request.fields['stok'] = barang.stok.toString();
    request.fields['harga'] = barang.harga.toString();

    if(gambar != null){
      request.files.add(await http.MultipartFile.fromPath('gambar', gambar.path));
    }

    final response = await request.send();
    if(response.statusCode == 200){
      final responseData = await http.Response.fromStream(response);
      return json.decode(responseData.body);
    }else{
      throw Exception('Data gagal dikirim');
    }
  }

  Future<void> deleteBarang(int id)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    await http.delete(Uri.parse('$baseUrl/barang/hapus/$id'),
    headers: {'Authorization': 'Bearer $token'});
  }

  Future<List<Barang>> searchBarang(String cari)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.post(Uri.parse('$baseUrl/barang/cari'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
      },
      body: json.encode({'cari': cari}));
    
    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Barang.fromJson(item)).toList();
    }else
    throw Exception('Data gagal dimuat');
  }

  Future<List<Beli>> getAllBeli()async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.get(Uri.parse('$baseUrl/beli'),
    headers: {'Authorization': 'Bearer $token'});

    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => Beli.fromJson(item)).toList();
    }else{
      throw Exception('Data gagal dimuat');
    }
  }

  Future<Map<String, dynamic>> addBeli(Beli beli)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.post(Uri.parse('$baseUrl/beli/tambah'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode(beli.toJson()));

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> cekStatus(String transaksiID)async{
    final key = await SharedPreferences.getInstance();
    final token = key.getString('token');

    final response = await http.post(Uri.parse('$baseUrl/beli/status'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: json.encode({'transaction_id': transaksiID}));
    return json.decode(response.body);
  }
}

<?php

namespace App\Http\Controllers;

use App\Models\Barang;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class BarangApiController extends Controller
{
    public function index(){
        $data = Barang::all();
        return response()->json(['message' => 'Berhasil menampilkan semua data barang', 'success' => true, 'data' => $data]);
    }

    public function create(Request $request){
        $validator = Validator::make($request->all(),[
            'gambar' => 'required|image|mimes:jpg,jpeg,png',
            'nama_barang' => 'required',
            'stok' => 'required|numeric',
            'harga' => 'required|numeric',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'Ada kesalahan', 'success' => false, 'data' => $validator->errors()->all()]);
        }

        if($request->hasFile('gambar')){
            $gambar = $request->file('gambar');
            $nmgambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $nmgambar = null;
        }

        $data = Barang::create([
            'gambar' => $nmgambar,
            'nama_barang' => $request->nama_barang,
            'stok' => $request->stok,
            'harga' => $request->harga,
        ]);

        return response()->json(['message' => 'Barang berhasil di tambahkan', 'success' => true, 'data' => $data]);
    }

    public function update(Request $request){
        $validator = Validator::make($request->all(),[
            'gambar' => 'mimes:jpg,jpeg,png|image',
            'nama_barang' => 'required',
            'stok' => 'required|numeric',
            'harga' => 'required|numeric',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'Ada kesalahan', 'success' => false, 'data' => $validator->errors()->all()]);
        }

        $barang = Barang::where('id',$request->id)->first();
        if($request->hasFile('gambar')){
            if($barang->gambar && file_exists(public_path('images/'.$barang->gambar))){
                unlink(public_path('images/'.$barang->gambar));
            }

            $gambar = $request->file('gambar');
            $nmgambar = time() . '_' . $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $nmgambar = $barang->gambar;
        }

        $data = Barang::where('id',$request->id)->update([
            'gambar' => $nmgambar,
            'nama_barang' => $request->nama_barang,
            'stok' => $request->stok,
            'harga' => $request->harga,
        ]);

        return response()->json(['message' => 'Barang berhasil di update', 'success' => true, 'data' => $data]);
    }

    public function destroy($id){
        $barang = Barang::where('id',$id)->first();
        if($barang->gambar && file_exists(public_path('images/'.$barang->gambar))){
            unlink(public_path('images/'.$barang->gambar));
        }

        $data = Barang::where('id',$id)->delete();
        return response()->json(['message' => 'Barang berhasil dihapus', 'success' => true, 'data' => $data]);
    }

    public function search(Request $request){
        $cari = $request->cari;
        if(strlen($cari)){
            $data = Barang::where("nama_barang","like","%$cari%")->orWhere('stok','like',"%$cari%")->orWhere('harga','like',"%$cari%")->get();
        }else{
            $data = null;
        }
        return response()->json(['message' => 'Hasil pencarian barang', 'success' => true, 'data' => $data]);
    }
}

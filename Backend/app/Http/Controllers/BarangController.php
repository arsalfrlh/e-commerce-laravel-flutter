<?php

namespace App\Http\Controllers;

use App\Models\Barang;
use App\Models\Beli;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class BarangController extends Controller
{
    public function index(){
        $jml_user = User::count();
        $jml_barang = Barang::count();
        $jml_beli = Beli::count();
        $jml_pembelian = Beli::with('user')->where('id_user', Auth::user()->id)->count();

        $jml_paid = Beli::where('status','paid')->count();
        $jml_unpaid = Beli::where('status','unpaid')->count();
        $jml_kadaluarsa = Beli::where('status','expired')->count();
        $jml_cancel = Beli::where('status','cancel')->count();
        return view('main.index', ['jumlah_user' => $jml_user, 'jumlah_barang' => $jml_barang, 'jumlah_beli' => $jml_beli, 'jumlah_pembelian' => $jml_pembelian, 'jumlah_paid' => $jml_paid, 'jumlah_unpaid' => $jml_unpaid, 'jumlah_cancel' => $jml_cancel, 'jumlah_expired' => $jml_kadaluarsa]);
    }

    public function barang(Request $request){
        $cari = $request->cari;
        if(strlen($cari)){
            $barang = Barang::where('nama_barang','like',"%$cari%")->orWhere('stok','like',"%$cari%")->orWhere('harga','like',"%$cari%")->get();
        }else{
            $barang = Barang::all();
        }
        return view('main.barang', ['tampil' => $barang]);
    }

    public function create(){
        return view('main.tambah');
    }

    public function store(Request $request){
        $request->validate([
            'gambar' => 'required|image|mimes:jpg,jpeg,png',
            'nama_barang' => 'required',
            'stok' => 'required|numeric',
            'harga' => 'required|numeric',
        ]);

        if($request->hasFile('gambar')){
            $gambar = $request->file('gambar');
            $nmgambar = time(). '_'. $gambar->getClientOriginalName();
            $gambar->move(public_path('images'),$nmgambar);
        }else{
            $nmgambar = null;
        }

        Barang::create([
            'gambar' => $nmgambar,
            'nama_barang' => $request->nama_barang,
            'stok' => $request->stok,
            'harga' => $request->harga,
        ]);

        return redirect('/barang')->with('tambah','Berhasil menambahkan barang');
    }

    public function edit($id){
        $barang = Barang::where('id',$id)->get();
        return view('main.update',['tampil' => $barang]);
    }

    public function update(Request $request){
        $request->validate([
            'gambar' => 'image|mimes:jpg,jpeg,png',
            'nama_barang' => 'required',
            'stok' => 'required|numeric',
            'harga' => 'required|numeric',
        ]);

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

        Barang::where('id',$request->id)->update([
            'gambar' => $nmgambar,
            'nama_barang' => $request->nama_barang,
            'stok' => $request->stok,
            'harga' => $request->harga,
        ]);

        return redirect('/barang')->with('update','Barang berhasil di perbaharui');
    }

    public function destroy($id){
        $barang = Barang::where('id',$id)->first();
        if($barang->gambar && file_exists(public_path('images/'.$barang->gambar))){
            unlink(public_path('images/'.$barang->gambar));
        }

        Barang::where('id',$id)->delete();

        return redirect('/barang')->with('hapus','Barang berhasil di hapus');
    }
}

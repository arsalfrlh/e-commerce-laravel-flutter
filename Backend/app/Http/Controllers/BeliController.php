<?php

namespace App\Http\Controllers;

use App\Models\Barang;
use App\Models\Beli;
use App\Models\Payment;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;
use Midtrans\Config;
use Midtrans\Snap;

class BeliController extends Controller
{
    public function index(){
        $pembelian = Beli::with(['user','barang','payment'])->where('id_user',Auth::user()->id)->get();
        return view('main.pembelian',[ 'tampil' => $pembelian ]);
    }

    public function create($id){
        $barang = Barang::where('id',$id)->get();
        return view('main.beli',['tampil' => $barang]);
    }

    public function store(Request $request){
        $request->validate([
            'id_barang' => 'required',
            'jumlah' => 'required',
        ]);

        $barang = Barang::where('id',$request->id_barang)->first();
        $total = $barang->harga * $request->jumlah;

        if($request->jumlah > $barang->stok){
            return redirect()->back()->with('gagal','Maaf stok barag tidak tersedia');
        }

        $beli = Beli::create([
            'id_user' => Auth::user()->id,
            'id_barang' => $request->id_barang,
            'tanggal_beli' => now()->format('Y-m-d'),
            'jumlah' => $request->jumlah,
            'total' => $total,
            'status' => 'unpaid',
        ]);

        Config::$serverKey = config('midtrans.server_key');
        Config::$clientKey = config('midtrans.client_key'); 
        Config::$isProduction = false;
        Config::$isSanitized = true;
        Config::$is3ds = true;

        $transaksi = [
            "transaction_details" => [
                "order_id" => $beli->id,
                "gross_amount" => $total,
            ],
            "customer_details" => [
                "first_name" => Auth::user()->name,
                "email" => Auth::user()->email,
            ],
        ];

        $snapToken = Snap::getSnapToken($transaksi);
        return redirect()->back()->with('snapToken',$snapToken); //redirect ke halaman sebelumnya dan snapToken di simpan di session
    }

    public function payment(Request $request){ //untuk mengecek data dari ajax gunakan dd($data) dan inspek dan buka network dan lihat bagian name pilih payment
        $data = $request->all(); //hasil dari javascript ajax
        if($data['payment_type'] == 'bank_transfer'){ //payment bank
            $payment =  Payment::create([ //insert ke database
                'id_beli' => $data['order_id'],
                'transaction_id' => $data['transaction_id'],
                'order_id' => $data['order_id'],
                'payment_type' => $data['payment_type'],
                'merchant_id' => config('midtrans.merchant_id'),
                'gross_amount' => $data['gross_amount'],
                'transaction_time' => $data['transaction_time'],
                'transaction_status' => $data['transaction_status'],
                'payment_code' => $data['va_numbers'][0]['va_number'],
                'bank' => $data['va_numbers'][0]['bank'],
            ]);

            Beli::where('id',$payment->id_beli)->update([ //update tabel beli agar terisi jika payment ini sudah dibyar dan id paymentnya
                'id_payment' => $payment->id,
                'status' => 'paid',
            ]);

            $key = config('midtrans.server_key');
            $transaksiID = $payment->transaction_id;
            try{
                $response = Http::withBasicAuth($key, '')->get("https://api.sandbox.midtrans.com/v2/{$transaksiID}/status"); //cek status pembayaran
                $json = $response->json();

                $payment->expiry_time = $json['expiry_time']; //update payment dari cek status
                $payment->settlement_time = $json['settlement_time'];
                $payment->save();
            }catch(Exception $e){
                dd($e);
            }

        }elseif($data['payment_type'] == 'cstore'){ //payment cstore
            $payment =  Payment::create([
                'id_beli' => $data['order_id'],
                'transaction_id' => $data['transaction_id'],
                'order_id' => $data['order_id'],
                'payment_type' => $data['payment_type'],
                'merchant_id' => config('midtrans.merchant_id'),
                'gross_amount' => $data['gross_amount'],
                'transaction_time' => $data['transaction_time'],
                'transaction_status' => $data['transaction_status'],
                'payment_code' => $data['payment_code'],
            ]);

            Beli::where('id',$payment->id_beli)->update([
                'id_payment' => $payment->id,
                'status' => 'paid',
            ]);

            $key = config('midtrans.server_key');
            $transaksiID = $payment->transaction_id;
            try{
                $response = Http::withBasicAuth($key, '')->get("https://api.sandbox.midtrans.com/v2/{$transaksiID}/status");
                $json = $response->json();

                $payment->expiry_time = $json['expiry_time'];
                $payment->settlement_time = $json['settlement_time'];
                $payment->store = $json['store'];
                $payment->save();
            }catch(Exception $e){
                dd($e);
            };

        }elseif($data['payment_type'] == 'qris'){
            $payment =  Payment::create([
                'id_beli' => $data['order_id'],
                'transaction_id' => $data['transaction_id'],
                'order_id' => $data['order_id'],
                'payment_type' => $data['payment_type'],
                'merchant_id' => config('midtrans.merchant_id'),
                'gross_amount' => $data['gross_amount'],
                'transaction_time' => $data['transaction_time'],
                'transaction_status' => $data['transaction_status'],
            ]);

            Beli::where('id',$payment->id_beli)->update([
                'id_payment' => $payment->id,
                'status' => 'paid',
            ]);

            $key = config('midtrans.server_key');
            $transaksiID = $payment->transaction_id;
            try{
                $response = Http::withBasicAuth($key, '')->get("https://api.sandbox.midtrans.com/v2/{$transaksiID}/status");
                $json = $response->json();

                $payment->expiry_time = $json['expiry_time'];
                $payment->settlement_time = $json['settlement_time'];
                $payment->save();
            }catch(Exception $e){
                dd($e);
            };
        }
    }
}

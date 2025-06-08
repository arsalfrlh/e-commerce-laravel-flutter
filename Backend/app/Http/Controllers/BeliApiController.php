<?php

namespace App\Http\Controllers;

use App\Models\Barang;
use App\Models\Beli;
use App\Models\Payment;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Validator;

class BeliApiController extends Controller
{
    public function index(Request $request){
        $user = $request->user();
        $data = Beli::with(['user','barang','payment'])->where('id_payment', '!=', null)->where('id_user',$user->id)->get();
        return response()->json(['message' => 'Berhasil menampilkan semua data pembelian', 'success' => true, 'data' => $data]);
    }

    public function create(Request $request){
        $validator= Validator::make($request->all(),[
            'id_barang' => 'required|numeric',
            'jumlah' => 'required',
            'payment_type' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => 'false', 'data' => $validator->errors()->all()]);
        }

        $user = $request->user(); //mengabil data user dari authorization bearer sanctum user di flutter
        $barang = Barang::where('id',$request->id_barang)->first(); //first adalah Single object (langsung objek, tanpa array) |mengabil satu baris data barang dengan id yang di request
        $total = $request->jumlah * $barang->harga; //mengkalikan harga barang dengan total pesanan

        if($request->jumlah > $barang->stok){
            return response()->json(['message' => 'Maaf stok barang tidak tersedia', 'success' => false]);
        }

        $beli = Beli::create([ //menginsert data beli
            'id_user' => $user->id,
            'id_barang' => $request->id_barang,
            'tanggal_beli' => now()->format('Y-m-d'),
            'jumlah' => $request->jumlah,
            'total' => $total,
            'status' => 'unpaid',
        ]);

        $serverKey = config('midtrans.server_key');
        if($request->payment_type == 'bank_transfer'){ //pembayaran bank
            try{
                $response = Http::withBasicAuth($serverKey, '')->post('https://api.sandbox.midtrans.com/v2/charge',[
                    'payment_type' => $request->payment_type,
                    'bank_transfer' => [
                        'bank' => $request->bank,
                    ],
                    'transaction_details' => [
                        'order_id' => $beli->id,
                        'gross_amount' => $beli->total,
                    ],
                    'customer_details' => [
                        'first_name' => $user->name,
                        'email' => $user->email,
                    ],
                    'custom_expiry' => [
                        'order_time' => now()->format('Y-m-d H:i:s O'),
                        'expiry_duration' => 24,
                        'unit' => 'hour',
                    ],
                ]);

                $json = $response->json();
                $payment = Payment::create([ //menginsert data payment hasil json midtrans
                    'id_beli' => $beli->id,
                    'transaction_id' => $json['transaction_id'],
                    'order_id' => $json['order_id'],
                    'payment_type' => $json['payment_type'],
                    'merchant_id' => $json['merchant_id'],
                    'gross_amount' => $json['gross_amount'],
                    'transaction_time' => $json['transaction_time'],
                    'expiry_time' => $json['expiry_time'],
                    'transaction_status' => $json['transaction_status'],
                    'payment_code' => $json['va_numbers'][0]['va_number'],
                    'bank' => $json['va_numbers'][0]['bank'],
                ]);

                Beli::where('id',$beli->id)->update([ //mengupdate id_payment di table data beli tdi
                    'id_payment' => $payment->id,
                ]);

                $data = Beli::with(['barang','user','payment'])->where('id',$beli->id)->get(); //get adlah Array (index 0, 1, dst.) jdi return data harus data[0]|mengambil semua data pembelian, barang, user, dan payment

                return response()->json(['message' => 'Pembelian berhasil, silahkan lakukan pembayaran', 'success' => true, 'data' => $data]);
            }catch(Exception $e){
                Beli::where('id',$beli->id)->delete();
                return response()->json(['message' => $e->getMessage(), 'success' => false, 'data' => null]);
            }
        }elseif($request->payment_type == 'cstore'){ //payment Cstore
            try{
                $response = Http::withBasicAuth($serverKey, '')->post('https://api.sandbox.midtrans.com/v2/charge',[
                    'payment_type' => $request->payment_type,
                    'cstore' => [
                        'store' => $request->store,
                    ],
                    'transaction_details' => [
                        'order_id' => $beli->id,
                        'gross_amount' => $beli->total,
                    ],
                    'customer_details' => [
                        'first_name' => $user->name,
                        'email' => $user->email,
                    ],
                ]);

                $json = $response->json();
                $payment = Payment::create([
                    'id_beli' => $beli->id,
                    'transaction_id' => $json['transaction_id'],
                    'order_id' => $json['order_id'],
                    'payment_type' => $json['payment_type'],
                    'merchant_id' => $json['merchant_id'],
                    'gross_amount' => $json['gross_amount'],
                    'transaction_time' => $json['transaction_time'],
                    'expiry_time' => $json['expiry_time'],
                    'transaction_status' => $json['transaction_status'],
                    'payment_code' => $json['payment_code'],
                    'store' => $json['store'],
                ]);

                Beli::where('id',$beli->id)->update([
                    'id_payment' => $payment->id,
                ]);

                $data = Beli::with(['barang','user','payment'])->where('id',$beli->id)->get();

                return response()->json(['message' => 'Pembelian berhasil, silahkan lakukan pembayaran', 'success' => true, 'data' => $data]);
            }catch(Exception $e){
                Beli::where('id',$beli->id)->delete();
                return response()->json(['message' => $e->getMessage(), 'success' => false, 'data' => null]);
            }
        }elseif($request->payment_type == 'gopay'){ //payment gopay
            try{
                $response = Http::withBasicAuth($serverKey, '')->post('https://api.sandbox.midtrans.com/v2/charge',[
                    'payment_type' => $request->payment_type,
                    'transaction_details' => [
                        'order_id' => $beli->id,
                        'gross_amount' => $beli->total,
                    ],
                    'customer_details' => [
                        'first_name' => $user->name,
                        'email' => $user->email,
                    ],
                ]);

                $json = $response->json();
                $payment = Payment::create([
                    'id_beli' => $beli->id,
                    'transaction_id' => $json['transaction_id'],
                    'order_id' => $json['order_id'],
                    'payment_type' => $json['payment_type'],
                    'merchant_id' => $json['merchant_id'],
                    'gross_amount' => $json['gross_amount'],
                    'transaction_time' => $json['transaction_time'],
                    'expiry_time' => $json['expiry_time'],
                    'transaction_status' => $json['transaction_status'],
                    'qr_code' => $json['actions'][0]['url'],
                ]);

                Beli::where('id',$beli->id)->update([
                    'id_payment' => $payment->id,
                ]);

                $data = Beli::with(['barang','user','payment'])->where('id',$beli->id)->get();

                return response()->json(['message' => 'Pembelian berhasil, silahkan lakukan pembayaran', 'success' => true, 'data' => $data]);
            }catch(Exception $e){
                Beli::where('id',$beli->id)->delete();
                return response()->json(['message' => $e->getMessage(), 'success' => false, 'data' => null]);
            }
        }else{
            return response()->json(['message' => 'Pembelian gagal, Silahkan coba kembali', 'success' => false, 'data' => null]);
        }
    }

    public function status(Request $request){
        $validator = Validator::make($request->all(),[
            'transaction_id' => 'required',
        ]);

        if($validator->fails()){
            return response()->json(['message' => 'ada kesalahan', 'success' => false, 'data' => $validator->errors()->all()]);
        }

        $transaksiID = $request->transaction_id;
        $serverKey = config('midtrans.server_key');
        try{
            $response = Http::withBasicAuth($serverKey, '')->get("https://api.sandbox.midtrans.com/v2/{$transaksiID}/status");
            $data = $response->json();

            if($data['transaction_status'] == 'settlement'){ //jika statusnya API midtrans sudah dibayar maka akan mengupdate databse
                $order = Payment::where('transaction_id',$transaksiID)->first();
                Payment::where('id',$order->id)->update([ //update tabel payment
                    'settlement_time' => $data['settlement_time'],
                    'transaction_status' => $data['transaction_status'],
                ]);
                Beli::where('id',$order->id_beli)->update([ //update tabel beli
                    'status' => 'paid',
                ]);
            }

            if($data['transaction_status'] == 'expire'){
                $order = Payment::where('transaction_id',$transaksiID)->first();
                Payment::where('id',$order->id)->update([
                    'transaction_status' => $data['transaction_status'],
                ]);
                Beli::where('id',$order->id_beli)->update([
                    'status' => 'expired',
                ]);
            }

            if($data['transaction_status'] == 'cancel'){
                $order = Payment::where('transaction_id',$transaksiID)->first();
                Payment::where('id',$order->id)->update([
                    'transaction_status' => $data['transaction_status'],
                ]);
                Beli::where('id',$order->id_beli)->update([
                    'status' => 'cancel',
                ]);
            }

            return response()->json(['message' => 'Transaksi berhasil ditemukan', 'success' => true, 'data' => $data]);
        }catch(Exception $e){
            return response()->json(['message' => $e->getMessage(), 'success' => false, 'data' => null]);
        }
    }
}

<?php
use App\Http\Controllers\AuthController;
use App\Http\Controllers\BarangController;
use App\Http\Controllers\BeliController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::middleware('guest')->group(function(){
    Route::get('/login',[AuthController::class,'login'])->name('login'); //view login sudah include register
    Route::post('/login/proses',[AuthController::class,'loginProses']);
    Route::post('/register/proses',[AuthController::class,'registerProses']);
});

Route::get('/home',function(){
    return redirect('/index');
});

Route::middleware('auth')->group(function(){
    Route::get('/index',[BarangController::class,'index']);
    Route::get('/barang',[BarangController::class,'barang']);
    Route::get('/barang/tambah',[BarangController::class,'create']);
    Route::post('/barang/tambah/proses',[BarangController::class,'store']);
    Route::get('/barang/edit/{id}',[BarangController::class,'edit']);
    Route::put('/barang/update/proses',[BarangController::class,'update']);
    Route::delete('/barang/hapus/{id}',[BarangController::class,'destroy']);
    Route::get('/beli',[BeliController::class,'index']);
    Route::get('/beli/tambah/{id}',[BeliController::class,'create']);
    Route::post('/beli/tambah/proses',[BeliController::class,'store']);
    Route::post('/beli/payment',[BeliController::class,'payment']);
    Route::get('/logout',[AuthController::class,'logout']);
});
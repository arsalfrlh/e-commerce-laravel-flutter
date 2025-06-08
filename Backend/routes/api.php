<?php

use App\Http\Controllers\AuthApiController;
use App\Http\Controllers\BarangApiController;
use App\Http\Controllers\BeliApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/login',[AuthApiController::class,'login']);
Route::post('/register',[AuthApiController::class,'register']);

Route::middleware('auth:sanctum')->group(function(){
    Route::post('/logout',[AuthApiController::class,'logout']);
    Route::get('/barang',[BarangApiController::class,'index']);
    Route::post('/barang/tambah',[BarangApiController::class,'create']);
    Route::post('/barang/update',[BarangApiController::class,'update']);
    Route::delete('/barang/hapus/{id}',[BarangApiController::class,'destroy']);
    Route::post('/barang/cari',[BarangApiController::class,'search']);
    Route::get('/beli',[BeliApiController::class,'index']);
    Route::post('/beli/tambah',[BeliApiController::class,'create']);
    Route::post('/beli/status',[BeliApiController::class,'status']);
});

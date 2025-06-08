<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Beli extends Model
{
    protected $table = "beli";
    protected $fillable = ['id_user','id_barang','id_payment','tanggal_beli','jumlah','total','status'];

    public function user(){
        return $this->belongsTo(User::class,'id_user');
    }

    public function barang(){
        return $this->belongsTo(Barang::class,'id_barang');
    }

    public function payment(){
        return $this->belongsTo(Payment::class,'id_payment');
    }
}

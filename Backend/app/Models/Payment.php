<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $table = "payment";
    protected $fillable = ['id_beli','transaction_id','order_id','payment_type','merchant_id','gross_amount','transaction_time','expiry_time','settlement_time','transaction_status','payment_code','qr_code','bank','store'];
    
    public function beli(){
        return $this->belongsTo(Beli::class,'id_beli');
    }
}

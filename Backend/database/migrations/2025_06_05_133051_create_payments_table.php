<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('payment', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('id_beli');
            $table->string('transaction_id');
            $table->string('order_id');
            $table->string('payment_type');
            $table->string('merchant_id');
            $table->string('gross_amount');
            $table->date('transaction_time');
            $table->date('expiry_time');
            $table->date('settlement_time')->nullable();
            $table->enum('transaction_status',['pending','settlement','cancel','expire']);
            $table->string('payment_code')->nullable();
            $table->string('qr_code')->nullable();
            $table->string('bank')->nullable();
            $table->string('store')->nullable();
            $table->timestamps();

            $table->foreign('id_beli')->references('id')->on('beli')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payment');
    }
};

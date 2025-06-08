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
        Schema::create('beli', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('id_user');
            $table->integer('id_barang');
            $table->integer('id_payment')->nullable();
            $table->date('tanggal_beli');
            $table->integer('jumlah');
            $table->integer('total');
            $table->enum('status',['paid','unpaid','expired','cancel'])->default('unpaid');
            $table->timestamps();

            $table->foreign('id_user')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('id_barang')->references('id')->on('barang')->onDelete('cascade');
            $table->foreign('id_payment')->references('id')->on('payment')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('beli');
    }
};

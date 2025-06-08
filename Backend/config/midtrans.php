<?php
return [
    "server_key" => env('MIDTRANS_SERVER_KEY'),
    "merchant_id" => env('MIDTRANS_MERCHANT_ID'),
    "client_key" => env('MIDTRANS_CLIENT_KEY'),
    "is_production" => false,
    "is_sanitized" => true,
    "is_3ds" => true,
];
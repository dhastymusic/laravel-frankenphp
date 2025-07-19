<?php

return [
    'currency' => env('DONATION_CURRENCY', 'IDR'),
    'min_amount' => env('DONATION_MIN_AMOUNT', 10000),
    'max_amount' => env('DONATION_MAX_AMOUNT', 100000000),
    'fee_percentage' => env('DONATION_FEE_PERCENTAGE', 2.9),
    'fixed_fee' => env('DONATION_FIXED_FEE', 2000),
    'auto_approve_threshold' => env('DONATION_AUTO_APPROVE_THRESHOLD', 50000),
    'receipt_template' => env('DONATION_RECEIPT_TEMPLATE', 'default'),
];


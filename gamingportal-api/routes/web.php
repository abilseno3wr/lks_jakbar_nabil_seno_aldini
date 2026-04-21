<?php

use App\Http\Controllers\GameController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get("/games/{slug}/{version}/{path?}", [GameController::class, 'serve'])->where('path', '.*');


<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group.
|
*/

Route::get('/', function () {
    $wished = DB::select('select * from places where visited = false');
    $visited = DB::select('select * from places where visited = true');

    return view('travelroad', ['wished' => $wished, 'visited' => $visited]);
});


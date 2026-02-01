<?php

use Illuminate\Support\Facades\DB;

Route::get('/', function () {
    $wished = DB::select('select * from places where visited = false');
    $visited = DB::select('select * from places where visited = true');

    return view('travelroad', [
        'wished' => $wished, 
        'visited' => $visited,
        'framework' => 'Laravel'
    ]);
});
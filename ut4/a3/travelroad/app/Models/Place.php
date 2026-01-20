<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Place extends Model
{
    use HasFactory;

    protected $table = 'places';
    
    protected $guarded = ['id'];

    protected $casts = [
        'visited' => 'boolean',
    ];
}


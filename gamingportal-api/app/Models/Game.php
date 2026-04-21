<?php

namespace App\Models;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasManyThrough;

class Game extends Model
{
    protected $fillable = [
        'title',
        'description',
        'slug',
        'thumbnail',
        'created_by',
    ];

    public function versions(): HasMany
    {
        return $this->hasMany(GameVersion::class);
    }

    public function scores(): HasManyThrough
    {
        return $this->hasManyThrough(Score::class, GameVersion::class);
    }

    public function createdBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}

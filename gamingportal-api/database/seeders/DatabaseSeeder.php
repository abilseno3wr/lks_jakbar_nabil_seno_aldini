<?php

namespace Database\Seeders;

use App\Models\Administrator;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();
        User::create([
            'username' => 'dev1',
            'password' => Hash::make('zhab123'),
        ]);
        User::create([
            'username' => 'play1',
            'password' => Hash::make('zhab123'),
        ]);
        Administrator::create([
            'username' => 'admin1',
            'password' => Hash::make('zhab123'),
        ]);
    }
}

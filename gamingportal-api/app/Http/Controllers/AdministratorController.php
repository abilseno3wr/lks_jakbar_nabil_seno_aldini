<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Administrator;
use Illuminate\Http\Request;

class AdministratorController extends Controller
{
        public function indexAllAdmins()
        {
            $admins = Administrator::all();
            return response()->json([
                'totalElements' => $admins->count(),
                'content' => $admins,
            ]);
        }
}

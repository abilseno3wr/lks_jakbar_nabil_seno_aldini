<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Game;
use App\Models\Administrator;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function signUp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            "username" => "required|unique:users,username|min:4|max:60",
            "password" => "required|min:5|max:15",
        ], [
            "username.required" => "Username required",
            "password.required" => "Password required",
        ]);

        if ($validator->fails()) {
            return response()->json([
                "status" => "invalid",
                "message" => $validator->errors()->first(),
            ], 400);
        }

        $data = $validator->validated();

        $user = User::create([
            "username" => $data['username'],
            "password" => Hash::make($data['password'])
        ]);


        return response()->json([
            "status" => "success",
            "username" => $user->username,
            "isAdministrator" => false,
            "isDeveloper" => false,
        ]);
    }
    public function signIn(Request $request)
    {
        $data = $request->validate([
            "username" => "required|min:4|max:60",
            "password" => "required|min:5|max:20"
        ]);
        $user = null;

        if (Str::startsWith($data['username'], 'admin')) {
            $user = Administrator::where('username', $data['username'])->first();
        }
        if (!$user) {
            $user = User::where('username', $data['username'])->first();
        }

        if (!$user || !Hash::check($data['password'], $user->password)) {
            return response()->json([
                "status" => "invalid",
                "message" => "Wrong username or password"
            ], 401);
        }

        $token = $user->createToken("auth_token")->plainTextToken;
        $isAdministrator = $user instanceof Administrator;

        return response()->json([
            "status" => "success",
            "token" => $token,
            "username" => $user->username,
            "isDeveloper" => $isAdministrator ? false : Game::where('created_by', $user->id)->exists(),
            "isAdministrator" => $isAdministrator,
        ]);
    }

    public function signOut(Request $request) {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            "status" => "success"
        ]);
    }
}

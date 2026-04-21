<?php

namespace App\Http\Middleware;

use App\Models\Administrator;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureAdministrator
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user instanceof Administrator) {
            return response()->json([
                'status' => 'forbidden',
                'message' => 'You are not the administrator',
            ], 403);
        }

        return $next($request);
    }
}


	
<?php

use App\Http\Controllers\AdministratorController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\GameController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/v1/auth/signin', [AuthController::class, 'signIn']);
Route::post('/v1/auth/signup', [AuthController::class, 'signUp']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/v1/auth/signout', [AuthController::class, 'signOut']);

    // route game
    Route::get('/v1/games', [GameController::class, 'index']);
    Route::get('/v1/games/{slug}', [GameController::class, 'show']);
    Route::post('/v1/games', [GameController::class, 'store']);
    Route::put('/v1/games/{slug}', [GameController::class, 'update']);
    Route::delete('/v1/games/{slug}', [GameController::class, 'destroy']);
    Route::get('/v1/games/{slug}/download', [GameController::class, 'downloadLatestZip']);
    Route::get('/v1/games/{slug}/scores', [GameController::class, 'showHighScores']);
    Route::post('/v1/games/{slug}/scores', [GameController::class, 'uploadScore']);
    Route::get('/v1/games/{slug}/download', [GameController::class, 'downloadLatestZip']);
});
Route::middleware(['auth:sanctum', 'is_admin'])->group(function () {
    Route::get('/v1/admins', [AdministratorController::class, 'indexAllAdmins']);
    // route user
    Route::get('/v1/users', [UserController::class, 'indexAllUsers']);
    Route::get('/v1/users/{username}', [UserController::class, 'showUserDetail']);
    Route::post('/v1/users', [UserController::class, 'storeUser']);
    Route::put('/v1/users/{username}', [UserController::class, 'updateUser']);
    Route::delete('/v1/users/{username}', [UserController::class, 'deleteUser']);
});
Route::post('/v1/games/{slug}/upload', [GameController::class, 'upload']);

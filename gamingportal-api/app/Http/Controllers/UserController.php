<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Validator;
use App\Models\Administrator;
use App\Models\Game;
use App\Models\Score;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    public function indexAllAdmins()
    {
        $admins = Administrator::all();
        return response()->json([
            'totalElements' => $admins->count(),
            'content' => $admins,
        ]);
    }

    public function storeUser(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required|unique:users,username|min:4|max:60',
            'password' => 'required|min:5|max:20',
        ], [
            'username.unique' => 'Username already exists',

            "username.required" => "Username is missing",
            "password.required" => "Password is missing",
        ]);

        if ($validator->fails()) {
            return response()->json([
                "status" => "invalid",
                "message" => $validator->errors()->first()
            ], 400);
        }

        $data = $validator->validated();

        $newUser = User::create([
            'username' => $data['username'],
            'password' => Hash::make($data['password']),
        ]);

        return response()->json([
            'status' => 'success',
            'username' => $newUser->username,
        ], 201);
    }

    public function indexAllUsers()
    {
        $users = User::all();

        return response()->json([
            'totalElements' => $users->count(),
            'content' => $users,
        ]);
    }

    public function updateUser(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'sometimes|exists:users,username|min:4|max:60',
            'password' => 'sometimes|min:5|max:20',
        ], [
            'username.unique' => 'Username already exists',

            "username.required" => "Username is missing",
            "password.required" => "Password is missing",
        ]);




        if ($validator->fails()) {
            return response()->json([
                "status" => "invalid",
                "message" => $validator->errors()->first()
            ], 400);
        }

        $data = $validator->validated();

        $user = User::find($id);
        if (!$user) {
            return response()->json([
                'status' => 'not-found',
                'message' => 'User not found',
            ], 404);
        }

        if (isset($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        }

        $user->update($data);

        return response()->json([
            'status' => 'success',
            'username' => $user->username,
        ]);
    }

    public function deleteUser($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                'status' => 'not-found',
                'message' => 'User not found',
            ], 404);
        }

        $user->delete();

        return response()->noContent();
    }

    public function showUserDetail($username)
    {
        $user = User::where('username', $username)->first();

        if (!$user) {
            return response()->json([
                'status' => 'not-found',
                'message' => 'User not found',
            ], 404);
        }

        $isSelf = auth()->id() === $user->id;

        $authoredGames = Game::query()
            ->where('created_by', $user->id)
            ->when(!$isSelf, fn($q) => $q->whereHas('versions'))
            ->withCount('scores as score_count')
            ->withMax('versions as latest_upload_at', 'created_at')
            ->orderByDesc('latest_upload_at')
            ->get()
            ->map(function (Game $game) {
                $latestVersion = $game->versions()->latest('created_at')->first();
                $thumbnail = $game->thumbnail;

                if (!$thumbnail && $latestVersion) {
                    $candidate = public_path("games/{$game->slug}/{$latestVersion->version}/thumbnail.png");
                    $thumbnail = file_exists($candidate)
                        ? "/games/{$game->slug}/{$latestVersion->version}/thumbnail.png"
                        : null;
                }

                return [
                    'slug' => $game->slug,
                    'title' => $game->title,
                    'description' => $game->description,
                    'thumbnail' => $thumbnail,
                    'scoreCount' => (int) ($game->score_count ?? 0),
                    'uploadTimestamp' => optional($latestVersion?->created_at)?->toISOString(),
                ];
            })
            ->values();

        $scores = Score::where('user_id', $user->id)
            ->with('gameVersion.game')
            ->get();

        $highscores = $scores
            ->filter(fn($score) => $score->gameVersion && $score->gameVersion->game)
            ->groupBy(fn($score) => $score->gameVersion->game->id)
            ->map(function ($group) {
                $best = $group->reduce(function ($carry, $item) {
                    if (!$carry) {
                        return $item;
                    }

                    if ((int) $item->score > (int) $carry->score) {
                        return $item;
                    }

                    if (
                        (int) $item->score === (int) $carry->score
                        && $item->created_at
                        && $carry->created_at
                        && $item->created_at->lt($carry->created_at)
                    ) {
                        return $item;
                    }

                    return $carry;
                });
                $game = $best->gameVersion->game;

                return [
                    'game' => [
                        'slug' => $game->slug,
                        'title' => $game->title,
                        'description' => $game->description,
                    ],
                    'score' => (int) $best->score,
                    'timestamp' => $best->created_at?->toISOString(),
                ];
            })
            ->sortBy(fn($item) => strtolower($item['game']['title']))
            ->values();

        return response()->json([
            'username' => $user->username,
            'registeredTimestamp' => $user->created_at?->toISOString(),
            'authoredGames' => $authoredGames,
            'highscores' => $highscores,
        ]);
    }
}

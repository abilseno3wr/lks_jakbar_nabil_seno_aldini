<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Game;
use App\Models\GameVersion;
use App\Models\Score;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Laravel\Sanctum\PersonalAccessToken;
use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;
use Symfony\Component\HttpFoundation\Response;
use ZipArchive;

class GameController extends Controller
{
    public function index(Request $request)
    {
        $request->validate([
            'page' => 'nullable|integer|min:0',
            'size' => 'nullable|integer|min:1|max:50',
            'sortBy' => 'nullable|in:title,popular,uploaddate',
            'sortDir' => 'nullable|in:asc,desc',
        ]);

        $page = (int) $request->query('page', 0);
        $size = (int) $request->query('size', 10);
        $sortBy = $request->query('sortBy', 'title');
        $sortDir = $request->query('sortDir', 'asc');

        $query = Game::query()
            ->whereHas('versions')
            ->with('createdBy')
            ->withCount('scores as score_count')
            ->withMax('versions as latest_upload_at', 'created_at');

        if ($sortBy === 'title') {
            $query->orderBy('title', $sortDir);
        } elseif ($sortBy === 'popular') {
            $query->orderBy('score_count', $sortDir);
        } else {
            $query->orderBy('latest_upload_at', $sortDir);
        }

        $totalElements = (clone $query)->count();
        $games = $query->skip($page * $size)->take($size)->get();

        $content = $games->map(function (Game $game) {
            $latestVersion = $game->versions()->latest('created_at')->first();
            $thumbnail = $game->thumbnail;

            if (!$thumbnail && $latestVersion) {
                $candidate = public_path("games/{$game->slug}/{$latestVersion->version}/thumbnail.png");
                $thumbnail = file_exists($candidate)
                    ? "/games/{$game->slug}/{$latestVersion->version}/thumbnail.png"
                    : null;
            }

            return [
                'title' => $game->title,
                'slug' => $game->slug,
                'description' => $game->description,
                'thumbnail' => $thumbnail,
                'uploadTimestamp' => optional($latestVersion?->created_at)?->toISOString(),
                'author' => optional($game->createdBy)->username,
                'scoreCount' => (int) ($game->score_count ?? 0),
            ];
        })->values();

        $isLastPage = (($page + 1) * $size) >= $totalElements;

        return response()->json([
            'page' => $page,
            'size' => $content->count(),
            'totalElements' => $totalElements,
            'isLastPage' => $isLastPage,
            'content' => $content,
        ]);
    }

    public function show(string $slug)
    {
        $game = Game::where('slug', $slug)->with('createdBy')->first();

        if (!$game) {
            return response()->json(['status' => 'not-found', 'message' => 'Not found'], 404);
        }

        $latestVersion = $game->versions()->latest('created_at')->first();
        $thumbnail = $game->thumbnail;

        if (!$thumbnail && $latestVersion) {
            $candidate = public_path("games/{$game->slug}/{$latestVersion->version}/thumbnail.png");
            $thumbnail = file_exists($candidate)
                ? "/games/{$game->slug}/{$latestVersion->version}/thumbnail.png"
                : null;
        }

        return response()->json([
            'slug' => $game->slug,
            'title' => $game->title,
            'description' => $game->description,
            'thumbnail' => $thumbnail,
            'author' => optional($game->createdBy)->username,
            'scoreCount' => (int) $game->scores()->count(),
            'gamePath' => $latestVersion ? "/games/{$game->slug}/{$latestVersion->version}/index.html" : null,
            'downloadPath' => "/api/v1/games/{$game->slug}/download",
            'isAuthor' => (int) auth()->id() === (int) $game->created_by,
        ]);
    }


    public function store(Request $request)
    {
        $data = $request->validate([
            'title' => 'required|string|min:3|max:60',
            'description' => 'required|string|max:200',
        ]);

        $generatedSlug = Str::slug($data['title']);

        if (Game::where('slug', $generatedSlug)->exists()) {
            return response()->json([
                'status' => 'invalid',
                'message' => 'Game title already exists',
            ], 400);
        }

        Game::create([
            'title' => $data['title'],
            'description' => $data['description'],
            'slug' => $generatedSlug,
            'created_by' => auth()->id(),
        ]);

        return response()->json([
            'status' => 'success',
            'slug' => $generatedSlug,
        ], 201);
    }

    public function update(Request $request, string $slug)
    {
        $data = $request->validate([
            'title' => 'required|string|min:3|max:60',
            'description' => 'required|string|max:200',
        ]);

        $game = Game::where('slug', $slug)->first();
        if (!$game) {
            return response()->json([
                'status' => 'not-found',
                'message' => 'Game not found',
            ], 404);
        }

        $user = $request->user();
        if ((int) $user->id !== (int) $game->created_by) {
            return response()->json([
                'status' => 'forbidden',
                'message' => 'You are not the game author',
            ], 403);
        }

        $targetSlug = Str::slug($data['title']);
        if ($targetSlug !== $game->slug && Game::where('slug', $targetSlug)->exists()) {
            return response()->json([
                'status' => 'invalid',
                'message' => 'Game title already exists',
            ], 400);
        }

        $oldSlug = $game->slug;
        $game->title = $data['title'];
        $game->description = $data['description'];
        $game->slug = $targetSlug;

        if ($oldSlug !== $targetSlug) {
            $oldDir = public_path("games/{$oldSlug}");
            $newDir = public_path("games/{$targetSlug}");

            if (is_dir($oldDir) && !is_dir($newDir)) {
                @rename($oldDir, $newDir);
            }
            $game->versions()->get()->each(function (GameVersion $version) use ($targetSlug) {
                $version->storage_path = "games/{$targetSlug}/{$version->version}/";
                $version->save();
            });
        }

        if ($game->thumbnail) {
            $game->thumbnail = preg_replace('#^/games/[^/]+/#', "/games/{$game->slug}/", $game->thumbnail);
        }

        $game->save();

        return response()->json([
            'status' => 'success',
            'slug' => $game->slug,
        ]);
    }
    private function nextVersionLabel(Game $game): string
    {
        $latestVersionNumber = $game->versions()
            ->get()
            ->map(fn($v) => (int) preg_replace('/\D+/', '', (string) $v->version))
            ->max() ?? 0;

        return 'v' . ($latestVersionNumber + 1);
    }

    private function buildZipFromDirectory(string $sourceDir): ?string
    {
        $tmpZip = tempnam(sys_get_temp_dir(), 'gamezip_');
        $zipFilePath = $tmpZip . '.zip';
        @unlink($tmpZip);

        $zip = new ZipArchive();
        if ($zip->open($zipFilePath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== true) {
            return null;
        }

        $files = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($sourceDir, RecursiveDirectoryIterator::SKIP_DOTS),
            RecursiveIteratorIterator::LEAVES_ONLY
        );

        foreach ($files as $file) {
            if (!$file->isFile()) {
                continue;
            }

            $absolute = $file->getRealPath();
            if (!$absolute) {
                continue;
            }

            $relative = substr($absolute, strlen($sourceDir) + 1);
            $zip->addFile($absolute, $relative);
        }

        $zip->close();

        return $zipFilePath;
    }
    private function isZipContentSafe(ZipArchive $zip): bool
    {
        for ($i = 0; $i < $zip->numFiles; $i++) {
            $entryName = (string) $zip->getNameIndex($i);
            if (str_contains($entryName, '../') || str_starts_with($entryName, '/')) {
                return false;
            }
        }

        return true;
    }

    public function upload(Request $request, string $slug)
    {
        $validator = Validator::make($request->all(), [
            'zipfile' => 'required|file|mimes:zip',
            'thumbnail' => 'nullable|image|mimes:png,jpg,jpeg,webp|max:2048',
            'token' => 'required|string',
        ], [
            "zipfile.required" => "Zipfile is missing",
            "token.required" => "Token is missing"
        ]);

        if ($validator->fails()) {
            return response($validator->errors()->first());
        }

        $game = Game::where('slug', $slug)->first();
        if (!$game) {
            return response("Not Found", 404);
        }

        $user = auth()->user();
        if ($request->filled('token')) {
            $pat = PersonalAccessToken::findToken($request->input('token'));
            if (!$pat) {
                return response('Invalid token', 401);
            }
            $user = $pat->tokenable;
        }

        if (!$user || (int) $user->id !== (int) $game->created_by) {
            return response('User is not author of the game', 403);
        }

        $validator = Validator::make($request->all(), [
            'zipfile' => 'required|file|mimes:zip',
            'thumbnail' => 'nullable|image|mimes:png,jpg,jpeg,webp|max:2048',
            'token' => 'required|string',
        ], [
            "zipfile.required" => "Zipfile is missing",
            "token.required" => "Token is missing"
        ]);

        if ($validator->fails()) {
            return response($validator->errors()->first());
        }

        $versionLabel = $this->nextVersionLabel($game);

        $extractRel = "games/{$game->slug}/{$versionLabel}";
        $extractAbs = public_path($extractRel);
        File::ensureDirectoryExists($extractAbs, 0755, true);

        $zipPath = $request->file('zipfile')->getRealPath();
        $zip = new ZipArchive();
        if ($zip->open($zipPath) !== true) {
            return response('Cannot open zip', 400);
        }

        if (!$this->isZipContentSafe($zip)) {
            $zip->close();

            return response('Invalid zip content', 400);
        }

        $zip->extractTo($extractAbs);
        $zip->close();

        if ($request->hasFile('thumbnail')) {
            $request->file('thumbnail')->move($extractAbs, 'thumbnail.png');
        }

        $storagePath = "{$extractRel}/";
        $thumbnailPath = file_exists("{$extractAbs}/thumbnail.png")
            ? "/{$extractRel}/thumbnail.png"
            : null;
        GameVersion::create([
            'game_id' => $game->id,
            'version' => $versionLabel,
            'storage_path' => $storagePath,
        ]);

        $game->thumbnail = $thumbnailPath;
        $game->save();

        return response()->json([
            'status' => 'success',
            'version' => $versionLabel,
            'gamePath' => "/{$extractRel}/index.html",
            'thumbnail' => $thumbnailPath,
        ], 201);
    }

    public function showHighScores(string $slug)
    {
        $game = Game::where('slug', $slug)->first();

        if (!$game) {
            return response()->json([
                'status' => 'not-found',
                'message' => 'Not found',
            ], 404);
        }

        $scores = Score::query()
            ->whereHas('gameVersion', fn($q) => $q->where('game_id', $game->id))
            ->with('user')
            ->orderByDesc('score')
            ->orderBy('created_at')
            ->get();

        $bestPerUser = $scores
            ->filter(fn($score) => $score->user)
            ->groupBy('user_id')
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

                return [
                    'username' => $best->user->username,
                    'score' => (int) $best->score,
                    'timestamp' => $best->created_at?->toISOString(),
                ];
            })
            ->sortByDesc('score')
            ->values();

        return response()->json([
            'scores' => $bestPerUser,
        ]);
    }

    public function uploadScore(Request $request, string $slug)
    {
        $game = Game::where('slug', $slug)->first();
        if (!$game) {
            return response()->json([
                'status' => 'not-found',
                'message' => 'Not found',
            ], 404);
        }

        $data = $request->validate([
            'score' => 'required|integer',
        ]);

        $latestVersion = $game->versions()->latest('created_at')->first();
        if (!$latestVersion) {
            return response()->json([
                'status' => 'invalid',
                'message' => 'Game has no uploaded version',
            ], 400);
        }

        $score = Score::create([
            'user_id' => auth()->id(),
            'game_version_id' => $latestVersion->id,
            'score' => $data['score'],
        ]);

        return response()->json([
            'score' => (int) $score->score,
            'timestamp' => $score->created_at?->toISOString(),
        ], 201);
    }

    public function downloadLatestZip(string $slug)
    {

        $game = Game::where('slug', $slug)->first();

        if (!$game) {
            return response()->json(['status' => 'not-found', 'message' => 'Not found'], 404);
        }

        $latestVersion = $game->versions()->latest('created_at')->first();
        if (!$latestVersion) {
            return response()->json(['status' => 'not-found', 'message' => 'No uploaded version'], 404);
        }

        $versionDir = public_path("games/{$game->slug}/{$latestVersion->version}");
        if (!is_dir($versionDir)) {
            return response()->json(['status' => 'not-found', 'message' => 'No uploaded version'], 404);
        }

        $zipFilePath = $this->buildZipFromDirectory($versionDir);
        if (!$zipFilePath) {
            return response()->json(['status' => 'error', 'message' => 'Cannot create zip'], 500);
        }

        return response()->download($zipFilePath, "{$game->slug}-{$latestVersion->version}.zip")
            ->deleteFileAfterSend(true);
    }

    public function destroy(string $slug)
    {
        $game = Game::where('slug', $slug)->first();
        if (!$game) {
            return response()->json([
                'status' => 'not-found',
                'message' => 'Game not found',
            ], 404);
        }

        $user = auth()->user();
        if ((int) $user->id !== (int) $game->created_by) {
            return response()->json([
                'status' => 'forbidden',
                'message' => 'You are not the game author',
            ], 403);
        }

        File::deleteDirectory(public_path("games/{$game->slug}"));
        $game->delete();

        return response()->noContent();
    }


    public function serve(string $slug, string $version, ?string $path = null)
    {
        $base = public_path("games/{$slug}/{$version}");
        if (!is_dir($base)) {
            abort(404);
        }

        $path = $path ?: 'index.html';
        $full = realpath($base . '/' . ltrim($path, '/'));
        $baseReal = realpath($base);

        if (!$full || !$baseReal || !str_starts_with($full, $baseReal) || !file_exists($full)) {
            abort(404);
        }

        return response()->file($full);
    }
}

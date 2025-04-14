<?php

use App\Http\Controllers\ShirtController;
use App\Http\Controllers\RecommendationController;

/*
|--------------------------------------------------------------------------
| Shirt Routes
|--------------------------------------------------------------------------
*/

// Get all shirts (wardrobe)
Route::get('/shirts', [ShirtController::class, 'index']);

// Get a single shirt by ID
Route::get('/shirts/{id}', [ShirtController::class, 'show']);

// Upload a new shirt (image + color)
Route::post('/shirts', [ShirtController::class, 'store']);

// Update a shirt (optional for editing)
Route::put('/shirts/{id}', [ShirtController::class, 'update']);

// Delete a shirt
Route::delete('/shirts/{id}', [ShirtController::class, 'destroy']);

/*
|--------------------------------------------------------------------------
| Recommendation Routes
|--------------------------------------------------------------------------
*/

// Get color recommendations based on weather
Route::get('/shirts/{id}/recommendation', [RecommendationController::class, 'getRecommendation']);
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ShirtController extends Controller
{
    public function getRecommendation($shirtId, Request $request) {
        $weather = $request->query('weather'); // e.g. sunny, rainy, etc.

        // Basic recommendation logic (temporary placeholder)
        $recommendation = [
            'sunny' => ['#ffffff', '#e3f2fd'],
            'rainy' => ['#1e1e1e', '#607d8b'],
            'cloudy' => ['#9e9e9e', '#b0bec5'],
        ];

        $colors = $recommendation[$weather] ?? [];

        return response()->json([
            'shirt_id' => $shirtId,
            'weather' => $weather,
            'recommended_colors' => $colors
        ]);
    }
}
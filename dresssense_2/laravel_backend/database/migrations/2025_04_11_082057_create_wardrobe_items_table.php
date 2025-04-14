<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('wardrobe_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('shirt_id')->constrained()->onDelete('cascade');
            $table->string('category')->nullable(); // e.g. "casual", "formal"
            $table->string('occasion')->nullable(); // e.g. "party", "work"
            $table->string('note')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('wardrobe_items');
    }
};

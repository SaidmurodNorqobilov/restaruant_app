package com.example.restaurantapp

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        // 1. Eng birinchi bo'lib kalitni o'rnatamiz
        MapKitFactory.setApiKey("d8509166-c9f8-4bd8-b2fc-d076071d93b3")

        // 2. Keyin initialize qilamiz
        MapKitFactory.initialize(this)

        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        // Bu yerda faqat super qolsa kifoya, chunki kalit tepada berildi
        super.configureFlutterEngine(flutterEngine)
    }
}
package com.example.flutter_map_routes

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MapKitFactory.setApiKey("23093f28-fb9e-4f26-a8d1-a35f016a5724")
    super.configureFlutterEngine(flutterEngine)
  }
}
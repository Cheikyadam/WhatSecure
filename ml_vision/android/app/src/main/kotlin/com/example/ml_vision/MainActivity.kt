package com.example.ml_vision

import android.graphics.BitmapFactory
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull

class MainActivity: FlutterActivity() {
    private val CHANNEL = "image_depth_channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getImageColorDepth") {
                val imagePath = call.argument<String>("imagePath")
                if (imagePath != null) {
                    val colorDepth = getImageColorDepth(imagePath)
                    result.success(colorDepth)
                } else {
                    result.error("ARGUMENT_ERROR", "imagePath argument is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getImageColorDepth(imagePath: String): Int {
        return try {
            val options = BitmapFactory.Options()
            options.inJustDecodeBounds = true
            BitmapFactory.decodeFile(imagePath, options)

            // Calculate color depth in bits per pixel
            val colorDepth = options.outWidth / options.outMimeType!!.length * 8
            colorDepth
        } catch (e: Exception) {
            Log.e("ImageDepthHandler", "Error retrieving image color depth: ${e.message}")
            -1
        }
    }
}

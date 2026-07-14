package com.urban.callmemo

import android.content.ContentUris
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val mediaStoreChannel = "com.urban.callmemo/mediastore"
    private val callRecordingChannel = "com.urban.callmemo/call_recording"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, mediaStoreChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "recentAudio" -> {
                        val windowSeconds = call.argument<Int>("windowSeconds") ?: 300
                        try {
                            result.success(queryRecentAudio(windowSeconds))
                        } catch (e: Exception) {
                            result.error("MEDIASTORE", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, callRecordingChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openAutoRecordSettings" -> {
                        val brand = call.argument<String>("brand")
                        try {
                            result.success(
                                CallRecordingSettingsHelper.openAutoRecordSettings(this, brand),
                            )
                        } catch (e: Exception) {
                            result.error("CALL_RECORDING", e.message, null)
                        }
                    }
                    "openPhoneApp" -> {
                        try {
                            result.success(CallRecordingSettingsHelper.openPhoneApp(this))
                        } catch (e: Exception) {
                            result.error("CALL_RECORDING", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun queryRecentAudio(windowSeconds: Int): List<Map<String, Any?>> {
        val cutoffSec = System.currentTimeMillis() / 1000L - windowSeconds
        val collection = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL)
        } else {
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
        }

        val projection = mutableListOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.DISPLAY_NAME,
            MediaStore.Audio.Media.DATE_MODIFIED,
            MediaStore.Audio.Media.DURATION,
        )
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            projection.add(MediaStore.Audio.Media.RELATIVE_PATH)
        }
        projection.add(MediaStore.Audio.Media.DATA)

        val selection = "${MediaStore.Audio.Media.DATE_MODIFIED} >= ?"
        val args = arrayOf(cutoffSec.toString())
        val sort = "${MediaStore.Audio.Media.DATE_MODIFIED} DESC"

        val out = mutableListOf<Map<String, Any?>>()
        contentResolver.query(collection, projection.toTypedArray(), selection, args, sort)
            ?.use { cursor ->
                val idCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
                val nameCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DISPLAY_NAME)
                val modCol = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATE_MODIFIED)
                val durCol = cursor.getColumnIndex(MediaStore.Audio.Media.DURATION)
                val relCol = cursor.getColumnIndex(MediaStore.Audio.Media.RELATIVE_PATH)
                val dataCol = cursor.getColumnIndex(MediaStore.Audio.Media.DATA)

                while (cursor.moveToNext()) {
                    val id = cursor.getLong(idCol)
                    val name = cursor.getString(nameCol) ?: continue
                    val modifiedSec = cursor.getLong(modCol)
                    val relative = if (relCol >= 0) cursor.getString(relCol) else null
                    val data = if (dataCol >= 0) cursor.getString(dataCol) else null
                    val durationMs = if (durCol >= 0) cursor.getLong(durCol) else 0L

                    val haystack = "${relative.orEmpty()} $name".lowercase()
                    if (!looksLikeCallRecording(haystack)) continue

                    val uri = ContentUris.withAppendedId(collection, id).toString()
                    out.add(
                        mapOf(
                            "path" to data,
                            "uri" to uri,
                            "displayName" to name,
                            "relativePath" to relative,
                            "modifiedMs" to modifiedSec * 1000L,
                            "durationMs" to durationMs,
                        ),
                    )
                }
            }
        return out
    }

    private fun looksLikeCallRecording(haystack: String): Boolean {
        val keywords = listOf(
            "call", "phone", "record", "rec", "звон", "телефон",
            "phonerecord", "callrec", "call_rec", "voice",
        )
        return keywords.any { haystack.contains(it) }
    }
}

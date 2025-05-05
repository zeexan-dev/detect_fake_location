package com.xeex.detect_fake_location

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Context
import android.os.Build
import android.provider.Settings
import android.app.AppOpsManager
import android.os.Process
import android.location.LocationManager
import android.location.Location

class DetectFakeLocationPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "detect_fake_location")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "detectFakeLocation") {
            val isMock = checkMockLocation(context)
            result.success(isMock)
        } else {
            result.notImplemented()
        }
    }

    private fun checkMockLocation(context: Context): Boolean {
        return checkApi31AndAbove(context) ||
               checkApi23To30(context) ||
               checkPreApi23(context)
    }

    // Check for Android 12+ (API 31+)
    private fun checkApi31AndAbove(context: Context): Boolean {
      if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
          return false
      }

      val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
      val providers = locationManager.getProviders(true) // true = only enabled providers

      return try {
          for (provider in providers) {
              val location = locationManager.getLastKnownLocation(provider)
              if (location?.isMock == true) {
                  return true
              }
          }
          false
      } catch (e: SecurityException) {
          false
      }
  }

    // Check for Android 6.0 to 11 (API 23-30)
    private fun checkApi23To30(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M || 
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            return false
        }

        val appOpsManager = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        return try {
            appOpsManager.checkOp(
                AppOpsManager.OPSTR_MOCK_LOCATION,
                Process.myUid(),
                context.packageName
            ) == AppOpsManager.MODE_ALLOWED
        } catch (e: Exception) {
            false
        }
    }
    // Check for Android below 6.0 (pre-API 23)
    private fun checkPreApi23(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return false
        }

        return try {
            !Settings.Secure.getString(
                context.contentResolver,
                Settings.Secure.ALLOW_MOCK_LOCATION
            ).isNullOrEmpty()
        } catch (e: Settings.SettingNotFoundException) {
            false
        } catch (e: Exception) {
            false
        }
    }

  
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
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


/** DetectFakeLocationPlugin */
class DetectFakeLocationPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext 
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "detect_fake_location")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if(call.method == "detectFakeLocation"){
      val isMock = isMockLocationEnabled(context)
      result.success(isMock)
    }
    else {
      result.notImplemented()
    }
  }

  fun isMockLocationEnabled(context: Context): Boolean {
    var isMockLocation = false
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        // On Marshmallow or later, check if the app has the mock location permission
        val appOpsManager = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
          try {
            isMockLocation = appOpsManager.checkOp(AppOpsManager.OPSTR_MOCK_LOCATION, Process.myUid(), context.packageName) == AppOpsManager.MODE_ALLOWED
          }
          catch(e: Exception) {
            isMockLocation = false
          }
        
        
    } else {
        // Before Marshmallow, check if mock location is enabled in developer options
        
       try {
         isMockLocation = !Settings.Secure.getString(context.contentResolver, Settings.Secure.ALLOW_MOCK_LOCATION).isNullOrEmpty()
       }
       catch(e: Settings.SettingNotFoundException) {
         isMockLocation = false
       } 
    }
    return isMockLocation
}

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

package com.sstonn.flutter_wear_os_connectivity

import android.net.Uri
import android.util.Log
import android.util.Pair
import androidx.annotation.NonNull
import com.google.android.gms.wearable.*
import com.google.android.gms.wearable.CapabilityClient.FILTER_ALL
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import java.io.*
import kotlin.coroutines.CoroutineContext
import kotlin.io.path.pathString

class FlutterWearOsConnectivityPlugin : FlutterPlugin, MethodCallHandler {

    private val pluginController = FlutterWearOsConnectivityController()

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(binding.binaryMessenger, "sstonn/flutter_wear_os_connectivity")
        channel.setMethodCallHandler(this)

        val callbackChannel = MethodChannel(binding.binaryMessenger, "sstonn/flutter_wear_os_connectivity_callback")
        callbackChannel.setMethodCallHandler(this)

        pluginController.initialize(binding.binaryMessenger, binding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginController.deinitialize()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.d("WEAROS", "[WEAROS PLUGIN] ${call.method}" )
        pluginController.execute(call, result)
    }

}




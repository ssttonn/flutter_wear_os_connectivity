package com.sstonn.flutter_wear_os_connectivity

import android.content.Intent
import android.util.Log
import com.google.android.gms.wearable.*
import java.util.*

class ListenerService: WearableListenerService() {
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("Service#StartCommand: ", "Start")
        return super.onStartCommand(intent, flags, startId)
    }

    override fun onCreate() {
        super.onCreate()
        Log.d("Service#OnCreate: ", "CREATE")
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d("Service#OnDestroy: ", "DESTROY")
    }

    override fun onDataChanged(p0: DataEventBuffer) {
        super.onDataChanged(p0)
        Log.d("Service#DataChanged:", p0.toString())
    }

    override fun onMessageReceived(p0: MessageEvent) {
        super.onMessageReceived(p0)
        Log.d("Service#MessageReceived", p0.toString())
        Wearable.getMessageClient(this).sendMessage(p0.sourceNodeId,"/service-path","Received from service at ${Date().time}".toByteArray())
    }

    override fun onConnectedNodes(p0: MutableList<Node>) {
        super.onConnectedNodes(p0)
        Log.d("Service#onNodes", p0.toString())
    }

    override fun onCapabilityChanged(p0: CapabilityInfo) {
        super.onCapabilityChanged(p0)
        Log.d("Service#CapChanged", p0.toString())
    }
}
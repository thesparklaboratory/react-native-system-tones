package com.sparklaboratory.systemtones

import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.WritableMap
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = SystemTonesModule.NAME)
class SystemTonesModule(reactContext: ReactApplicationContext) :
    NativeSystemTonesSpec(reactContext) {

    private var thePlayer: MediaPlayer? = null

    override fun getName(): String {
        return NAME
    }

    override fun list(soundType: String, promise: Promise) {
        val manager = RingtoneManager(getReactApplicationContext())
        val ringtoneManagerType = when (soundType) {
            "alarm" -> RingtoneManager.TYPE_ALARM
            "ringtone" -> RingtoneManager.TYPE_RINGTONE
            "notification" -> RingtoneManager.TYPE_NOTIFICATION
            else -> RingtoneManager.TYPE_ALL
        }

        manager.setType(ringtoneManagerType)
        val cursor = manager.cursor
        val list: WritableArray = Arguments.createArray()

        try {
            while (cursor.moveToNext()) {
                val notificationTitle = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
                val notificationUri = cursor.getString(RingtoneManager.URI_COLUMN_INDEX)
                val id = cursor.getInt(RingtoneManager.ID_COLUMN_INDEX)

                val newSound: WritableMap = Arguments.createMap()
                newSound.putString("title", notificationTitle)
                newSound.putString("url", "$notificationUri/$id")
                newSound.putInt("soundId", id)

                list.pushMap(newSound)
            }
            promise.resolve(list)
        } catch (e: Exception) {
            promise.reject("list_error", e)
        }
    }

    override fun play(sound: ReadableMap) {
        try {
            val soundUrl = sound.getString("url") ?: ""
            val notification = if (soundUrl.isEmpty()) {
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            } else {
                Uri.parse(soundUrl)
            }
            thePlayer?.stop()
            thePlayer = MediaPlayer.create(getReactApplicationContext(), notification)
            thePlayer?.start()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun stop() {
        try {
            thePlayer?.stop()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    companion object {
        const val NAME = "SystemTones"
    }
}
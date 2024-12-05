package com.sparklaboratory.systemtones

import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = SystemTonesModule.NAME)
class SystemTonesModule(reactContext: ReactApplicationContext) :
        NativeSystemTonesSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  override fun list(soundType: String): Array<Any> {
    val manager = RingtoneManager(reactContext)
    val ringtoneManagerType =
            when (soundType) {
              "alarm" -> RingtoneManager.TYPE_ALARM
              "ringtone" -> RingtoneManager.TYPE_RINGTONE
              "notification" -> RingtoneManager.TYPE_NOTIFICATION
              else -> RingtoneManager.TYPE_ALL
            }

    manager.setType(ringtoneManagerType)
    val cursor = manager.cursor
    val list = mutableListOf<Map<String, String>>()

    while (cursor.moveToNext()) {
      val notificationTitle = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
      val notificationUri = cursor.getString(RingtoneManager.URI_COLUMN_INDEX)
      val id = cursor.getString(RingtoneManager.ID_COLUMN_INDEX)

      val newSound =
              mapOf("title" to notificationTitle, "url" to "$notificationUri/$id", "soundID" to id)
      list.add(newSound)
    }
    return list.toTypedArray()
  }

  override fun play(soundUrl: String) {
    try {
      val notification =
              if (soundUrl.isEmpty()) {
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
              } else {
                Uri.parse(soundUrl)
              }
      thePlayer?.stop()
      thePlayer = MediaPlayer.create(reactContext, notification)
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

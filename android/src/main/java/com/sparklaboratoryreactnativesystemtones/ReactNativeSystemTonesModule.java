package com.sparklaboratoryreactnativesystemtones;

import androidx.annotation.NonNull;
import android.database.Cursor;
import android.media.MediaPlayer;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.module.annotations.ReactModule;

@ReactModule(name = ReactNativeSystemTonesModule.NAME)
public class ReactNativeSystemTonesModule extends ReactContextBaseJavaModule {
    public static final String NAME = "ReactNativeSystemTones";
    private ReactApplicationContext reactContext;
    private MediaPlayer thePlayer;

    public ReactNativeSystemTonesModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return NAME;
    }

    public void list(String soundType, final Promise promise) {
        RingtoneManager manager = new RingtoneManager(this.reactContext);
        Integer ringtoneManagerType;

        if (soundType.equals("alarm")) {
            ringtoneManagerType = RingtoneManager.TYPE_ALARM;
        } else if (soundType.equals("ringtone")) {
            ringtoneManagerType = RingtoneManager.TYPE_RINGTONE;
        } else if (soundType.equals("notification")) {
            ringtoneManagerType = RingtoneManager.TYPE_NOTIFICATION;
        } else {
            ringtoneManagerType = RingtoneManager.TYPE_ALL;
        }

        manager.setType(ringtoneManagerType);
        Cursor cursor = manager.getCursor();
        WritableArray list = Arguments.createArray();

        while (cursor.moveToNext()) {
            String notificationTitle = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX);
            String notificationUri = cursor.getString(RingtoneManager.URI_COLUMN_INDEX);
            String id = cursor.getString(RingtoneManager.ID_COLUMN_INDEX);

            WritableMap newSound = Arguments.createMap();
            newSound.putString("title", notificationTitle);
            newSound.putString("url", notificationUri + "/" + id );
            newSound.putString("soundID", id );

            list.pushMap(newSound);
        }
        promise.resolve(list);
    }


    public void play(String soundUrl) {
        try {
            Uri notification;
            if (soundUrl == null || soundUrl.length() == 0) {
                notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
            } else {
                notification = Uri.parse(soundUrl);
            }
            if (thePlayer != null) thePlayer.stop();
            thePlayer = MediaPlayer.create(this.reactContext, notification);
            thePlayer.start();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void stop() {
        try {
            if (thePlayer != null) thePlayer.stop();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

package com.sparklaboratory.reactnativesystemtones;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.Promise;

abstract class ReactNativeSystemTonesSpec extends ReactContextBaseJavaModule {
  ReactNativeSystemTonesSpec(ReactApplicationContext context) {
    super(context);
  }

  public abstract void list(String soundType, Promise promise);
  public abstract void play(String soundUrl);
  public abstract void stop();
}

package com.sparklaboratory.reactnativesystemtones;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.module.model.ReactModuleInfo;
import com.facebook.react.module.model.ReactModuleInfoProvider;
import com.facebook.react.TurboReactPackage;

import java.util.HashMap;
import java.util.Map;

public class ReactNativeSystemTonesPackage extends TurboReactPackage {

  @Nullable
  @Override
  public NativeModule getModule(String name, ReactApplicationContext reactContext) {
    if (name.equals(ReactNativeSystemTonesModule.NAME)) {
      return new ReactNativeSystemTonesModule(reactContext);
    } else {
      return null;
    }
  }

  @Override
  public ReactModuleInfoProvider getReactModuleInfoProvider() {
    return () -> {
      final Map<String, ReactModuleInfo> moduleInfos = new HashMap<>();
      boolean isTurboModule = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED;
      moduleInfos.put(
              ReactNativeSystemTonesModule.NAME,
              new ReactModuleInfo(
                      ReactNativeSystemTonesModule.NAME,
                      ReactNativeSystemTonesModule.NAME,
                      false, // canOverrideExistingModule
                      false, // needsEagerInit
                      true, // hasConstants
                      false, // isCxxModule
                      isTurboModule // isTurboModule
      ));
      return moduleInfos;
    };
  }
}

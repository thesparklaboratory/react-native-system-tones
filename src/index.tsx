import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package '@sparklaboratory/react-native-system-tones' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const ReactNativeSystemTonesModule = isTurboModuleEnabled
  ? require('./NativeReactNativeSystemTones').default
  : NativeModules.ReactNativeSystemTones;

const ReactNativeSystemTones = ReactNativeSystemTonesModule
  ? ReactNativeSystemTonesModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export interface Sound {
  soundID: string;
  url: string;
  title: string;
}

export const enum SOUND_TYPES {
  RINGTONES = 'ringtone',
  ALARMS = 'alarm',
  NOTIFICATIONS = 'notification',
  ALL = 'all',
}

export function list(soundType: SOUND_TYPES): Promise<Sound[]> {
  return ReactNativeSystemTones.list(soundType);
}

export function play(sound: Sound): void {
  return ReactNativeSystemTones.play(sound.url);
}

export function stop(): void {
  return ReactNativeSystemTones.stop();
}

const ReactNativeSystemTones = require('./NativeReactNativeSystemTones').default;

export interface Sound {
  soundID: string
  url: string
  title: string
}

export const enum SOUND_TYPES {
  RINGTONES = "ringtone",
  ALARMS = "alarm",
  NOTIFICATIONS = "notification",
  ALL = "all",
}

export function list(soundType: SOUND_TYPES): Promise<Sound[]> {
  return ReactNativeSystemTones.list(soundType)
}

export function play(sound: Sound): void {
  return ReactNativeSystemTones.play(sound.url)
}

export function stop(): void {
  return ReactNativeSystemTones.stop()
}

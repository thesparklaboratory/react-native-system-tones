const ReactNativeSystemTones = require('./NativeReactNativeSystemTones').default;

export interface Sound {
  soundID: string
  url: string
  title: string
}

export function list(soundType: string): Promise<Sound[]> {
  return ReactNativeSystemTones.list(soundType)
}

export function play(sound: Sound): void {
  return ReactNativeSystemTones.play(sound.url)
}

export function stop(): void {
  return ReactNativeSystemTones.stop()
}

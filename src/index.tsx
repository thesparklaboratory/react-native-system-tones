import ReactNativeSystemTones from './NativeReactNativeSystemTones'
import type { Sound } from './NativeReactNativeSystemTones'
export type { Sound } from './NativeReactNativeSystemTones'

export function list(soundType: string): Promise<Sound[]> {
  return ReactNativeSystemTones.list(soundType)
}

export function play(sound: Sound): void {
  return ReactNativeSystemTones.play(sound.url)
}

export function stop(): void {
  return ReactNativeSystemTones.stop()
}

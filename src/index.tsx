import type { Sound } from './NativeSystemTones';
import SystemTones from './NativeSystemTones';

export type { Sound };

export const enum SOUND_TYPES {
  RINGTONES = 'ringtone',
  ALARMS = 'alarm',
  NOTIFICATIONS = 'notification',
  ALL = 'all',
}

export function list(soundType: SOUND_TYPES): Promise<Sound[]> {
  return SystemTones.list(soundType);
}

export function play(sound: Sound): void {
  return SystemTones.play(sound);
}

export function stop(): void {
  return SystemTones.stop();
}

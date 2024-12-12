import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Sound {
  soundId: number;
  url: string;
  title: string;
}

export interface Spec extends TurboModule {
  list(soundType: string): Promise<Sound[]>;
  play(sound: Sound): void;
  stop(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('SystemTones');

import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  list(soundType: string): Promise<Object[]>;
  play(soundUrl: string): void;
  stop(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('SystemTones');

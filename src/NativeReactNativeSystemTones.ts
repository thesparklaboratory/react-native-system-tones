import type { TurboModule } from 'react-native'
import { TurboModuleRegistry } from 'react-native'

export interface Sound {
  soundID: string
  url: string
  title: string
}

export interface Spec extends TurboModule {
  list(soundType: string): Promise<Sound[]>
  play(soundUrl: string): void
  stop(): void
}

export default TurboModuleRegistry.getEnforcing<Spec>('ReactNativeSystemTones')

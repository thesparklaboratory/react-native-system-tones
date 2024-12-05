import { Text, View, StyleSheet, Button } from 'react-native';
import {
  list,
  play,
  stop,
  SOUND_TYPES,
  type Sound,
} from '@sparklaboratory/react-native-system-tones';
import { useEffect, useState } from 'react';

export default function App() {
  const [sounds, setSounds] = useState<Sound[]>([]);

  useEffect(() => {
    list(SOUND_TYPES.ALL).then((results) => {
      setSounds(results);
    });
  }, []);

  return (
    <View style={styles.container}>
      <Text>System Tones</Text>
      {sounds.map((sound) => (
        <Button
          key={sound.soundID}
          title={sound.title}
          onPress={() => play(sound)}
        />
      ))}
      <Button title="Stop" onPress={stop} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

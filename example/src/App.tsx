import * as React from 'react';

import type { Sound } from '@sparklaboratory/react-native-system-tones';
import {
  list,
  play,
  SOUND_TYPES,
  stop,
} from '@sparklaboratory/react-native-system-tones';
import { Button, FlatList, StyleSheet, View } from 'react-native';

export default function App() {
  const [sounds, setSounds] = React.useState<Sound[]>([]);

  React.useEffect(() => {
    list(SOUND_TYPES.RINGTONES).then(setSounds);
  }, []);

  return (
    <View style={styles.container}>
      <FlatList
        data={sounds}
        renderItem={({ item }) => (
          <Button
            title={item.title}
            onPress={() => {
              stop();
              play(item);
            }}
          />
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});

# @sparklaboratory/react-native-system-tones

Provides access to the available system tones on the device.

## Installation

```sh
npm install @sparklaboratory/react-native-system-tones
```

## Usage

```js
import {
  list,
  play,
  stop,
  SOUND_TYPES,
} from '@sparklaboratory/react-native-system-tones';

// ...

const sounds = await list(SOUND_TYPES.RINGTONES);
// [ { soundID: 1, url: /path/to/file, title: "Sound Name" }]
play(sounds[1]);
setTimeout(() => stop(), 1000);
```

_SOUND_TYPES_

- RINGTONES
- ALARMS
- NOTIFICATIONS
- ALL

_NOTE_ that alarms, notifications and all are android only, using those 3
parameters on iOS will return to you the UI Sounds. Eventually _ALL_ will
include ringtones on iOS as well once some light refactoring is completed.

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
# @sparklaboratory/react-native-system-tones
List and use built-in system tones.

## Installation

```sh
npm install @sparklaboratory/react-native-system-tones
```

## Usage

```js
import { list, play, stop, SOUND_TYPES } from '@sparklaboratory/react-native-system-tones';

// ...

const sounds = await list(SOUND_TYPES.RINGTONES);
// [ { soundID: 1, url: /path/to/file, title: "Sound Name" }]
play(sounds[1]);
setTimeout(() => stop(), 1000);
```

*SOUND_TYPES*
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

---

Inspired and original implementation by [react-native-notification-sounds](https://github.com/saadqbal/react-native-notification-sounds)
Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)

const ReactNativeSystemTones = require('./NativeReactNativeSystemTones').default;
export function list(soundType) {
    return ReactNativeSystemTones.list(soundType);
}
export function play(sound) {
    return ReactNativeSystemTones.play(sound.url);
}
export function stop() {
    return ReactNativeSystemTones.stop();
}

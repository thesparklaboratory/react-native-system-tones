import * as React from 'react';
import { Button, FlatList, StyleSheet, View } from 'react-native';
import { list, play, stop } from '@sparklaboratory/react-native-system-tones';
export default function App() {
    const [sounds, setSounds] = React.useState([]);
    React.useEffect(() => {
        list("ringtone").then(setSounds);
    }, []);
    return (React.createElement(View, { style: styles.container },
        React.createElement(FlatList, { data: sounds, renderItem: ({ item }) => React.createElement(Button, { title: item.title, onPress: () => { stop(); play(item); } }) })));
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

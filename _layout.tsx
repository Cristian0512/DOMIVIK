import {Stack} from 'expo-router';
import {theme} from '../src/theme';
export default function Layout(){return <Stack screenOptions={{headerShown:false,contentStyle:{backgroundColor:theme.bg}}}/>}

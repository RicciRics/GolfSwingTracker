/**
 * Golf Swing Tracker - Main App Component
 * Handles navigation between MainMenu and SwingScreen
 */

import React, {useState} from 'react';
import {StyleSheet, View, StatusBar} from 'react-native';
import MainMenu from './screens/MainMenu';
import SwingScreen from './screens/SwingScreen';

export type Screen = 'menu' | 'swing';

const App = (): JSX.Element => {
  const [currentScreen, setCurrentScreen] = useState<Screen>('menu');

  return (
    <View style={styles.container}>
      <StatusBar barStyle="light-content" backgroundColor="#1a1a2e" />
      {currentScreen === 'menu' ? (
        <MainMenu onNavigate={() => setCurrentScreen('swing')} />
      ) : (
        <SwingScreen onBack={() => setCurrentScreen('menu')} />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1a1a2e',
  },
});

export default App;

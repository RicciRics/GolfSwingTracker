/**
 * Main Menu Screen
 * Displays the app title and "Swing" button to start tracking
 */

import React from 'react';
import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  Dimensions,
  Image,
} from 'react-native';

const {width, height} = Dimensions.get('window');

interface MainMenuProps {
  onNavigate: () => void;
}

const MainMenu: React.FC<MainMenuProps> = ({onNavigate}) => {
  return (
    <View style={styles.container}>
      {/* Header Section */}
      <View style={styles.header}>
        <Text style={styles.title}>Golf Swing</Text>
        <Text style={styles.subtitle}>Tracker</Text>
      </View>

      {/* Icon Section */}
      <View style={styles.iconContainer}>
        <View style={styles.iconCircle}>
          <Text style={styles.iconText}>⛳</Text>
        </View>
      </View>

      {/* Description */}
      <View style={styles.descriptionContainer}>
        <Text style={styles.description}>
          Track your golf swing speed with precision
        </Text>
        <Text style={styles.subDescription}>
          Uses advanced motion detection
        </Text>
      </View>

      {/* Swing Button */}
      <TouchableOpacity
        style={styles.swingButton}
        onPress={onNavigate}
        activeOpacity={0.8}>
        <Text style={styles.swingButtonText}>Start Swing</Text>
      </TouchableOpacity>

      {/* Footer */}
      <View style={styles.footer}>
        <Text style={styles.footerText}>Position phone to capture full swing</Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1a1a2e',
    justifyContent: 'space-between',
    paddingVertical: 60,
  },
  header: {
    alignItems: 'center',
    marginTop: 40,
  },
  title: {
    fontSize: 48,
    fontWeight: '700',
    color: '#00ff88',
    letterSpacing: 2,
  },
  subtitle: {
    fontSize: 36,
    fontWeight: '300',
    color: '#ffffff',
    letterSpacing: 4,
  },
  iconContainer: {
    alignItems: 'center',
    marginVertical: 40,
  },
  iconCircle: {
    width: 150,
    height: 150,
    borderRadius: 75,
    backgroundColor: '#16213e',
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 3,
    borderColor: '#00ff88',
  },
  iconText: {
    fontSize: 80,
  },
  descriptionContainer: {
    alignItems: 'center',
    paddingHorizontal: 40,
  },
  description: {
    fontSize: 18,
    color: '#ffffff',
    textAlign: 'center',
    fontWeight: '500',
    marginBottom: 8,
  },
  subDescription: {
    fontSize: 14,
    color: '#00ff88',
    textAlign: 'center',
    fontWeight: '400',
  },
  swingButton: {
    backgroundColor: '#00ff88',
    marginHorizontal: 40,
    paddingVertical: 20,
    borderRadius: 30,
    alignItems: 'center',
    shadowColor: '#00ff88',
    shadowOffset: {width: 0, height: 4},
    shadowOpacity: 0.5,
    shadowRadius: 10,
    elevation: 8,
  },
  swingButtonText: {
    fontSize: 24,
    fontWeight: '700',
    color: '#1a1a2e',
    letterSpacing: 1,
  },
  footer: {
    alignItems: 'center',
    paddingHorizontal: 40,
  },
  footerText: {
    fontSize: 12,
    color: '#888',
    textAlign: 'center',
  },
});

export default MainMenu;

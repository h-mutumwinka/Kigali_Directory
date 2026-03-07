# kigali_city_directory

A Flutter-based Kigali Directory app with Firebase backend integration for listing and discovering places in Kigali.

## Features

- 📍 Browse and search places in Kigali
- 🗺️ Google Maps integration
- 🔐 Firebase Authentication (optional)
- ☁️ Cloud Firestore for data storage (works offline too)
- 📝 Create, edit, and manage your own listings
- 🔍 Search by name or category
- 📱 Cross-platform support (Android, iOS, Web)

## Getting Started

### Prerequisites

- Flutter SDK installed (3.10.4 or higher)
- Android Studio / Xcode for mobile development
- Google Maps API key (for map features)
- Firebase project (optional - app works offline without it)

### Installation

1. **Clone the repository**
   ```bash
   cd kigali_city_directory
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Google Maps API Key**
   - Get an API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Enable "Maps SDK for Android" and "Maps SDK for iOS"
   - Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` in:
     - `android/app/src/main/AndroidManifest.xml` (line 13)

4. **Configure Firebase (Optional)**
   
   The app works WITHOUT Firebase using local storage, but to enable cloud sync:
   
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android/iOS/Web apps to your Firebase project
   - Download `google-services.json` for Android → place in `android/app/`
   - Download `GoogleService-Info.plist` for iOS → place in `ios/Runner/`
   - Run: `flutterfire configure` to generate proper config
   - Or manually update `lib/firebase_options.dart` with your Firebase config

5. **Run the app**
   ```bash
   flutter run
   ```

## Configuration Files Updated

The following files have been fixed:
- ✅ `android/app/build.gradle.kts` - Fixed Firebase plugin configuration
- ✅ `android/build.gradle.kts` - Added proper dependencies
- ✅ `android/app/src/main/AndroidManifest.xml` - Added Maps API key and permissions
- ✅ `lib/firebase_options.dart` - Created Firebase options file
- ✅ `lib/main.dart` - Updated Firebase initialization
- ✅ `lib/screens/navigation_screen.dart` - Fixed bottom navigation bar
- ✅ `lib/screens/settings_screen.dart` - Connected to auth provider
- ✅ `lib/providers/auth_provider.dart` - Auto-detect logged-in user

## Usage

### Without Firebase (Local Mode)
The app works immediately with local storage. You can:
- Add places (stored locally)
- Browse and search places
- Use all features except cloud sync

### With Firebase (Cloud Mode)
Once configured:
- Sign up / Login to create an account
- Places sync across devices
- Real-time updates

### Adding a Place
1. Tap the "+" button on Home or My Listings screen
2. Fill in details (name, category, address, contact, description)
3. Enter latitude and longitude (e.g., -1.9441 for Kigali latitude, 30.0619 for longitude)
4. Tap "Save"

### Using the Map
- Tap the map icon in the app bar or bottom navigation
- View all places on Google Maps
- Tap markers to see place details

## Important Notes

1. **Google Maps API Key**: The map feature requires a valid API key. Get one from Google Cloud Console.

2. **Firebase (Optional)**: The app is designed to work offline. Firebase is only needed for:
   - User authentication
   - Cloud data sync
   - Multi-device access

3. **Coordinates**: Use these default coordinates for Kigali:
   - Latitude: -1.9441
   - Longitude: 30.0619

## Troubleshooting

**Map not showing?**
- Ensure Google Maps API key is properly configured in AndroidManifest.xml
- Enable required APIs in Google Cloud Console

**Firebase errors?**
- The app works without Firebase, so these can be ignored
- To fix: Configure Firebase properly or leave it in local mode

**Build errors?**
- Run `flutter clean && flutter pub get`
- Ensure Android SDK and build tools are installed

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
├── providers/                # State management
├── screens/                  # UI screens
├── services/                 # Backend services
└── widgets/                  # Reusable widgets
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Google Maps Flutter Plugin](https://pub.dev/packages/google_maps_flutter)

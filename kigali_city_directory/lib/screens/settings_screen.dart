import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as auth;
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification settings
  bool locationNotifications = true;
  bool bookingReminders = true;
  bool newListingsNotifications = false;

  // Display settings
  String selectedLanguage = 'English';
  String distanceUnit = 'Kilometers';
  String mapStyle = 'Standard';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF0D1B2A), // Dark blue AppBar
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==================== ACCOUNT SECTION ====================
          _buildSectionHeader('Account', Icons.person),
          const SizedBox(height: 8),
          
          _buildCard(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      (user?.displayName ?? user?.email ?? 'G').substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    user?.displayName ?? user?.email?.split('@')[0] ?? "Guest User",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.email ?? "Not logged in"),
                      Text(
                        'ID: ${user?.uid ?? 'none'}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.verified, 
                    color: user != null ? Colors.green : Colors.grey,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text("Edit Profile"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Edit profile feature")),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.security, color: Colors.blue),
                  title: const Text("Privacy & Security"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showPrivacyDialog();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ==================== NOTIFICATIONS SECTION ====================
          _buildSectionHeader('Notifications', Icons.notifications),
          const SizedBox(height: 8),
          
          _buildCard(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.location_on, color: Colors.blue),
                  title: const Text("Location Notifications"),
                  subtitle: const Text("Get notified about nearby places"),
                  value: locationNotifications,
                  onChanged: (value) {
                    setState(() => locationNotifications = value);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.event, color: Colors.orange),
                  title: const Text("Booking Reminders"),
                  subtitle: const Text("Reminders for your appointments"),
                  value: bookingReminders,
                  onChanged: (value) {
                    setState(() => bookingReminders = value);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.new_releases, color: Colors.green),
                  title: const Text("New Listings"),
                  subtitle: const Text("Alerts when new places are added"),
                  value: newListingsNotifications,
                  onChanged: (value) {
                    setState(() => newListingsNotifications = value);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ==================== APPEARANCE SECTION ====================
          _buildSectionHeader('Appearance', Icons.palette),
          const SizedBox(height: 8),
          
          _buildCard(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode, color: Colors.indigo),
                  title: const Text("Dark Mode"),
                  subtitle: const Text("Use dark theme"),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value ? "Dark mode enabled" : "Light mode enabled"),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.blue),
                  title: const Text("Language"),
                  subtitle: Text(selectedLanguage),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguageDialog(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.straighten, color: Colors.blue),
                  title: const Text("Distance Unit"),
                  subtitle: Text(distanceUnit),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showDistanceUnitDialog(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ==================== MAP SETTINGS SECTION ====================
          _buildSectionHeader('Map Settings', Icons.map),
          const SizedBox(height: 8),
          
          _buildCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.map_outlined, color: Colors.blue),
                  title: const Text("Map Style"),
                  subtitle: Text(mapStyle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showMapStyleDialog(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.my_location, color: Colors.blue),
                  title: const Text("Default Location"),
                  subtitle: const Text("Kigali, Rwanda"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Location settings coming soon")),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ==================== GENERAL SECTION ====================
          _buildSectionHeader('General', Icons.settings),
          const SizedBox(height: 8),
          
          _buildCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.storage, color: Colors.blue),
                  title: const Text("Storage & Cache"),
                  subtitle: const Text("Manage app data"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showStorageDialog(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Colors.blue),
                  title: const Text("Help & Support"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showHelpDialog(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blue),
                  title: const Text("About"),
                  subtitle: const Text("Version 1.0.0"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showAboutDialog(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star_outline, color: Colors.amber),
                  title: const Text("Rate This App"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Thank you for your support!")),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ==================== LOGOUT BUTTON ====================
          if (user != null) ...[
            _buildCard(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.red),
                onTap: () => _showLogoutDialog(authProvider),
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ==================== HELPER WIDGETS ====================
  
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade300),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.blue.shade300,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: child,
    );
  }

  // ==================== DIALOG METHODS ====================

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English'),
            _buildLanguageOption('Kinyarwanda'),
            _buildLanguageOption('French'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return RadioListTile<String>(
      title: Text(language),
      value: language,
      groupValue: selectedLanguage,
      onChanged: (value) {
        setState(() => selectedLanguage = value!);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Language changed to $value")),
        );
      },
    );
  }

  void _showDistanceUnitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Distance Unit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDistanceOption('Kilometers'),
            _buildDistanceOption('Miles'),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceOption(String unit) {
    return RadioListTile<String>(
      title: Text(unit),
      value: unit,
      groupValue: distanceUnit,
      onChanged: (value) {
        setState(() => distanceUnit = value!);
        Navigator.pop(context);
      },
    );
  }

  void _showMapStyleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Map Style"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMapStyleOption('Standard'),
            _buildMapStyleOption('Satellite'),
            _buildMapStyleOption('Terrain'),
            _buildMapStyleOption('Hybrid'),
          ],
        ),
      ),
    );
  }

  Widget _buildMapStyleOption(String style) {
    return RadioListTile<String>(
      title: Text(style),
      value: style,
      groupValue: mapStyle,
      onChanged: (value) {
        setState(() => mapStyle = value!);
        Navigator.pop(context);
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Privacy & Security"),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your privacy is important to us.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text("• Your data is stored securely"),
              Text("• We don't share your information"),
              Text("• You can delete your account anytime"),
              Text("• Location data is only used for navigation"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  void _showStorageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Storage & Cache"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cache Size: 12.5 MB"),
            SizedBox(height: 8),
            Text("Offline Data: 2.3 MB"),
            SizedBox(height: 8),
            Text("Total: 14.8 MB"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Cache cleared successfully")),
              );
            },
            child: const Text("Clear Cache"),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Help & Support"),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Need help?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text("📧 Email: support@kigalidirectory.rw"),
              SizedBox(height: 8),
              Text("📞 Phone: +250 788 000 000"),
              SizedBox(height: 8),
              Text("🌐 Website: www.kigalidirectory.rw"),
              SizedBox(height: 12),
              Text(
                "FAQ:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Q: How do I add a listing?"),
              Text("A: Tap the + button on Home or My Listings tab."),
              SizedBox(height: 8),
              Text("Q: How do I book an appointment?"),
              Text("A: Open any listing and tap 'Book Appointment'."),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("About Kigali Directory"),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Kigali City Services & Places Directory",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text("Version 1.0.0"),
              SizedBox(height: 12),
              Text(
                "Your comprehensive guide to essential services, leisure spots, and attractions in Kigali, Rwanda.",
              ),
              SizedBox(height: 12),
              Text("Features:"),
              Text("• Browse hospitals, libraries, restaurants"),
              Text("• Interactive map with navigation"),
              Text("• Book appointments"),
              Text("• Search and filter listings"),
              Text("• Real-time updates"),
              SizedBox(height: 12),
              Text("© 2024 Kigali Directory. All rights reserved."),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(auth.AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logged out successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
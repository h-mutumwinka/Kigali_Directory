import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'navigation_screen.dart';
import 'auth_wrapper.dart';

class WebDemoWrapper extends StatelessWidget {
  const WebDemoWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    if (kIsWeb) {
      return const MainNavigationScreen();
    }
    
    
    return const AuthWrapper();
  }
}

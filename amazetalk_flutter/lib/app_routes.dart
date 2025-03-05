import 'package:amazetalk_flutter/loader_page.dart';
import 'package:flutter/material.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'main.dart';
import 'onboarding_page.dart';
import 'sensor_pages.dart';

// Define a class to store your routes
class AppRoutes {
  // Define a GlobalKey to access the Navigator directly
  static const String login = '/';
  static const String register = '/register';
  static const String conversations = '/conversation';
  static const String loaderPage = '/loaderPage';
  static const String onboardingPage = '/onboardingPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case conversations:
        return MaterialPageRoute(
            builder: (_) =>

                // ConversationPage()
                SensorChatApp());
      case loaderPage:
        return MaterialPageRoute(builder: (_) => LoaderPage());
      case onboardingPage:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      default:
        return _errorRoute(settings.name ?? 'Unknown Route');
    }
  }

  // Error route for unrecognized routes
  static Route<dynamic> _errorRoute(String name) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(child: Text('No route defined for $name')),
      ),
    );
  }

  static push(String routeName) {
    // Navigate to details screen using named route
    navigatorKey.currentState?.pushNamed(routeName);
    // Navigator.pushNamed(context, route);
  }

  static pop() {
    navigatorKey.currentState?.pop();
    // Navigator.pop(context);
  }

  // Pop until a specific route is found
  static void go(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }
}

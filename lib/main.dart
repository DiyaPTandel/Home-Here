import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/splash_screen.dart';
import 'screens/add_property_page1.dart';
import 'screens/add_property_page2.dart';
import 'screens/change_password_page.dart';
import 'screens/owner_dashboard.dart';
import 'screens/owner_edit_profile_page.dart';
import 'screens/owner_profile_page.dart';
import 'screens/properties_page.dart';
import 'screens/property_added_success.dart';
import 'screens/theme.dart';
import 'screens/visit_requests_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final ValueNotifier<bool> isOwnerMode = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isOwnerMode,
      builder: (context, isOwner, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Home Here",
          theme: isOwner ? ownerTheme : userTheme,
          home: const SplashScreen(),
          routes: {
            OwnerDashboard.routeName: (_) => OwnerDashboard(),
            VisitRequestsPage.routeName: (_) => VisitRequestsPage(),
            PropertiesPage.routeName: (_) => PropertiesPage(),
            AddPropertyPage1.routeName: (_) => AddPropertyPage1(),
            AddPropertyPage2.routeName: (_) => AddPropertyPage2(),
            PropertyAddedSuccess.routeName: (_) => PropertyAddedSuccess(),
            OwnerProfilePage.routeName: (_) => OwnerProfilePage(),
            OwnerEditProfilePage.routeName: (_) => OwnerEditProfilePage(),
            ChangePasswordPage.routeName: (_) => ChangePasswordPage(),
          },
        );
      },
    );
  }
}

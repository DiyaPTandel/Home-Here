import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy & Security")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Change Password"),
              onTap: () {
                // Implement change password
              },
            ),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text("Enable Fingerprint Login"),
              onTap: () {
                // Implement biometric security
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Settings"),
              onTap: () {
                // Implement privacy settings
              },
            ),
          ],
        ),
      ),
    );
  }
}

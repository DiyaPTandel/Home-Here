import 'package:flutter/material.dart';
import 'change_pw.dart';
import 'privacy_setting_page.dart';

class PrivacySecurityPage extends StatelessWidget {
  PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy & Security"),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildListTile(
            Icons.lock_outline,
            "Change Password",
            "Update your account password",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordPage(),
                ),
              );
            },
          ),
          const Divider(),
          _buildListTile(
            Icons.privacy_tip_outlined,
            "Privacy Settings",
            "Manage your privacy preferences",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacySettingsPage()),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

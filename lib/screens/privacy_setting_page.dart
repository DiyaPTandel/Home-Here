import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool isProfilePublic = true;
  bool isActivityVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Settings"),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text("Make Profile Public"),
            subtitle: const Text("Allow others to see your profile"),
            value: isProfilePublic,
            onChanged: (val) {
              setState(() {
                isProfilePublic = val;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Show Activity Status"),
            subtitle: const Text("Allow others to see when you are active"),
            value: isActivityVisible,
            onChanged: (val) {
              setState(() {
                isActivityVisible = val;
              });
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}

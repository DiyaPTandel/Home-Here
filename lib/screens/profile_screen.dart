import 'dart:io';
import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'privacy_security.dart';
import 'signin_screen.dart';
import 'user_reviews_list.dart';
import 'visit_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Diya Tandel";
  String email = "diyatandel1809@gmail.com";
  String phone = "+91 9876543210";
  File? profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture & Info
            CircleAvatar(
              radius: 50,
              backgroundImage: profileImage != null
                  ? FileImage(profileImage!)
                  : AssetImage("assets/profile.png") as ImageProvider,
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(phone, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),

            // Edit Profile
            _buildListTile(
              Icons.person_outline,
              "Edit Profile",
              "Update your personal info",
              () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      currentName: name,
                      currentEmail: email,
                      currentPhone: phone,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    name = result['name'];
                    email = result['email'];
                    phone = result['phone'];
                    profileImage = result['profileImage'];
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Profile updated successfully")),
                  );
                }
              },
            ),
            const Divider(),

            // Visit Info
            _buildListTile(
              Icons.info_outline,
              "Visit Info",
              "View your visit requests",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisitInfoPage(userEmail: email),
                  ),
                );
              },
            ),
            const Divider(),

            // Reviews
            _buildListTile(Icons.reviews, "Reviews", "Check your reviews", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserReviewsPage(userEmail: email),
                ),
              );
            }),
            const Divider(),

            // Privacy & Security
            _buildListTile(
              Icons.security_outlined,
              "Privacy & Security",
              "Change password and privacy settings",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacySecurityPage(),
                  ),
                );
              },
            ),
            const Divider(),

            // Sign Out
            _buildListTile(
              Icons.logout,
              "Sign Out",
              "Log out from your account",
              () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                  (route) => false,
                );
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: color),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

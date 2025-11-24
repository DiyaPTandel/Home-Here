import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'owner_edit_profile_page.dart';
import 'change_password_page.dart';
import 'owner_signin_screen.dart'; // ✅ Added import

class OwnerProfilePage extends StatefulWidget {
  static const routeName = '/owner_profile';

  const OwnerProfilePage({super.key});

  @override
  State<OwnerProfilePage> createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends State<OwnerProfilePage> {
  final String name = 'Hensy Patel';
  final String email = 'hensypatel@gmail.com';
  final String phone = '+91 9876543210';
  final String location = 'Ahmedabad, Gujarat';
  final Color themeColor = const Color(0xFF004AAD);

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                final picked = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                Navigator.pop(ctx, picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                final picked = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                Navigator.pop(ctx, picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(ctx, null),
            ),
          ],
        ),
      ),
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showProfilePopup() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _profileImage != null
                        ? Image.file(
                            _profileImage!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/profile_placeholder.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF004AAD)),
                        onPressed: _pickImage,
                        tooltip: "Change Profile Photo",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeColor,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // Profile section without card
              Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: _showProfilePopup,
                        child: Hero(
                          tag: 'profile-photo',
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.transparent,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : const AssetImage(
                                        'assets/profile_placeholder.png',
                                      )
                                      as ImageProvider,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: themeColor,
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(email, style: TextStyle(color: Colors.grey[700])),
                  Text(phone, style: TextStyle(color: Colors.grey[700])),
                  Text(location, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
              const SizedBox(height: 20),
              // Menu items
              Expanded(
                child: ListView(
                  children: [
                    _buildMenuItem(
                      icon: Icons.edit_outlined,
                      title: 'Edit Profile',
                      color: themeColor,
                      onTap: () => Navigator.pushNamed(
                        context,
                        OwnerEditProfilePage.routeName,
                      ),
                    ),
                    _buildMenuItem(
                      icon: Icons.add_business_outlined,
                      title: 'Add Properties',
                      color: themeColor,
                      onTap: () =>
                          Navigator.pushNamed(context, '/add_property_1'),
                    ),
                    _buildMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      color: themeColor,
                      onTap: () => Navigator.pushNamed(
                        context,
                        ChangePasswordPage.routeName,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildMenuItem(
                      icon: Icons.logout_outlined,
                      title: 'Sign Out',
                      color: Colors.red,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: const Text('Sign out'),
                            content: const Text(
                              'Do you really want to sign out?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(ctx); // Close dialog

                                  // ✅ Redirect to OwnerSignInScreen and clear navigation stack
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OwnerSignInScreen(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );

                                  // Optional: show sign-out message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Signed out successfully'),
                                    ),
                                  );
                                },
                                child: const Text('Sign Out'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 24),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}

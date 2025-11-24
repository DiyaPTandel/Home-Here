import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'owner_signin_screen.dart';
import 'owner_dashboard.dart';
import '../main.dart'; // For isOwnerMode

class OwnerSignUpScreen extends StatefulWidget {
  const OwnerSignUpScreen({super.key});

  @override
  State<OwnerSignUpScreen> createState() => _OwnerSignUpScreenState();
}

class _OwnerSignUpScreenState extends State<OwnerSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirm = TextEditingController();
  final TextEditingController property = TextEditingController();
  final TextEditingController location = TextEditingController();

  bool isLoading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // 1️⃣ Firebase Auth Signup
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: pass.text.trim(),
          );

      String uid = userCredential.user!.uid;

      // 2️⃣ Save owner details to Firestore
      await FirebaseFirestore.instance.collection('owners').doc(uid).set({
        "name": name.text.trim(),
        "email": email.text.trim(),
        "phone": phone.text.trim(),
        "propertyName": property.text.trim(),
        "location": location.text.trim(),
        "userType": "owner",
        "createdAt": DateTime.now(),
      });

      // 3️⃣ Navigate to OwnerDashboard
      MyApp.isOwnerMode.value = true; // ensure owner theme
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OwnerDashboard()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Something went wrong";

      if (e.code == "email-already-in-use") {
        errorMessage = "This email is already registered";
      } else if (e.code == "weak-password") {
        errorMessage = "Password must be at least 6 characters";
      } else if (e.code == "invalid-email") {
        errorMessage = "Enter a valid email";
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF004AAD);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ---------- TOP WHITE CONTAINER ----------
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Owner Sign up",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004AAD),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: name,
                            decoration: const InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v!.isEmpty ? "Enter name" : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: email,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                v!.contains("@") ? null : "Invalid email",
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: "Phone Number",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                v!.length < 10 ? "Enter valid number" : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: pass,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                v!.length < 6 ? "Min 6 chars" : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: confirm,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Confirm password",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                v != pass.text ? "Passwords don’t match" : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: property,
                            decoration: const InputDecoration(
                              labelText: "Property Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: location,
                            decoration: const InputDecoration(
                              labelText: "Location",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _signUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    minimumSize: const Size(
                                      double.infinity,
                                      50,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text(
                                    "Continue",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  MyApp.isOwnerMode.value = true;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OwnerSignInScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Already have an owner account? Sign in",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

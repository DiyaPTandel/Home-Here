import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  static const routeName = '/change_password';

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String current = '';
  String newPass = '';
  String confirm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Current Password', border: OutlineInputBorder()),
              obscureText: true,
              onSaved: (v) => current = v ?? '',
            ),
            SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(labelText: 'New password', border: OutlineInputBorder()),
              obscureText: true,
              onSaved: (v) => newPass = v ?? '',
            ),
            SizedBox(height: 12),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirm password', border: OutlineInputBorder()),
              obscureText: true,
              onSaved: (v) => confirm = v ?? '',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _formKey.currentState!.save();
                if (newPass != confirm) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('New password and confirm do not match')));
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password updated successfully')));
                Navigator.pop(context);
              },
              child: Text('Update password'),
            )
          ]),
        ),
      ),
    );
  }
}

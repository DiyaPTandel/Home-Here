import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'property_added_success.dart';

class AddPropertyPage2 extends StatefulWidget {
  static const routeName = '/add_property_2';

  @override
  _AddPropertyPage2State createState() => _AddPropertyPage2State();
}

class _AddPropertyPage2State extends State<AddPropertyPage2> {
  final _formKey = GlobalKey<FormState>();
  String address = '';
  String city = '';
  String stateName = '';
  String pin = '';
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> prevData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text('Add New Property'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  'Location Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Address *',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (v) => address = v ?? '',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter address' : null,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'City *',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (v) => city = v ?? '',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Enter city' : null,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'State *',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (v) => stateName = v ?? '',
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Enter state' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'PIN code *',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (v) => pin = v ?? '',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter PIN code' : null,
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Adding GPS coordinates helps students find your property easily on maps.',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Previous'),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          if (currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('User not found'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // Save property to Firestore
                          final docRef = await FirebaseFirestore.instance
                              .collection('properties')
                              .add({
                                'ownerId': currentUser!.uid,
                                'name': prevData['name'] ?? '',
                                'type': prevData['type'] ?? 'Hostel',
                                'description': prevData['description'] ?? '',
                                'rules': prevData['rules'] ?? '',
                                'address': address,
                                'city': city,
                                'state': stateName,
                                'pin': pin,
                                'location': '$city, $stateName — 0 km',
                                'rating': 'New',
                                'image':
                                    'https://picsum.photos/200/140?random=5',
                                'createdAt': FieldValue.serverTimestamp(),
                              });

                          // Pass the new property to success page
                          final newProperty = {
                            'id': docRef.id,
                            'ownerId': currentUser!.uid,
                            'name': prevData['name'] ?? '',
                            'type': prevData['type'] ?? 'Hostel',
                            'description': prevData['description'] ?? '',
                            'rules': prevData['rules'] ?? '',
                            'address': address,
                            'city': city,
                            'state': stateName,
                            'pin': pin,
                            'location': '$city, $stateName — 0 km',
                            'rating': 'New',
                            'image': 'https://picsum.photos/200/140?random=5',
                          };

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PropertyAddedSuccess(
                                propertyData: newProperty,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPropertyPage extends StatefulWidget {
  final Map<String, dynamic> property;

  const EditPropertyPage({super.key, required this.property});

  @override
  _EditPropertyPageState createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String type;
  late String description;
  late String rules;
  late String city;
  late String stateName;
  late String pin;

  @override
  void initState() {
    super.initState();
    name = widget.property['name'] ?? '';
    type = widget.property['type'] ?? 'Hostel';
    description = widget.property['description'] ?? '';
    rules = widget.property['rules'] ?? '';
    city = widget.property['city'] ?? '';
    stateName = widget.property['state'] ?? '';
    pin = widget.property['pin'] ?? '';
  }

  void _saveProperty() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedProperty = {
        'name': name,
        'type': type,
        'description': description,
        'rules': rules,
        'city': city,
        'state': stateName,
        'pin': pin,
        'location': '$city, $stateName — 0 km',
        'rating': widget.property['rating'] ?? 'New',
        'image':
            widget.property['image'] ??
            'https://picsum.photos/200/140?random=5',
      };

      await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.property['id'])
          .update(updatedProperty);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Edited Successfully!')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.pop(context, {
          ...updatedProperty,
          'id': widget.property['id'],
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Property'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Text(
                    'Basic Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(
                      labelText: 'Property Name *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSaved: (v) => name = v ?? '',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter name' : null,
                  ),
                  SizedBox(height: 16),
                  Text('Property Type *', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 11),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: ['Hostel', 'Flat', 'PG'].map((t) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: t,
                            groupValue: type,
                            onChanged: (v) => setState(() => type = v!),
                            activeColor: Colors.blueAccent,
                          ),
                          SizedBox(width: 8),
                          Text(t),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: description,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSaved: (v) => description = v ?? '',
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: rules,
                    decoration: InputDecoration(
                      labelText: 'House Rules',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSaved: (v) => rules = v ?? '',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Location',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    initialValue: city,
                    decoration: InputDecoration(
                      labelText: 'City *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSaved: (v) => city = v ?? '',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter city' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: stateName,
                    decoration: InputDecoration(
                      labelText: 'State *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSaved: (v) => stateName = v ?? '',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter state' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: pin,
                    decoration: InputDecoration(
                      labelText: 'PIN code *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSaved: (v) => pin = v ?? '',
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _saveProperty,
                child: Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: const Color(0xFF1976D2),
                  elevation: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

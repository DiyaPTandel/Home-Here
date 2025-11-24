import 'package:flutter/material.dart';
import 'add_property_page2.dart';

class AddPropertyPage1 extends StatefulWidget {
  static const routeName = '/add_property_1';

  @override
  _AddPropertyPage1State createState() => _AddPropertyPage1State();
}

class _AddPropertyPage1State extends State<AddPropertyPage1> {
  final _formKey = GlobalKey<FormState>();
  String propertyName = '';
  String propertyType = 'Hostel';
  String description = '';
  String houseRules = '';

  @override
  Widget build(BuildContext context) {
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
                  'Basic Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Property Name *',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (v) => propertyName = v ?? '',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter property name' : null,
                ),
                SizedBox(height: 16),
                Text('Property Type *', style: TextStyle(fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['Hostel', 'Flat', 'PG'].map((type) {
                    return Expanded(
                      child: RadioListTile<String>(
                        title: Text(type),
                        value: type,
                        groupValue: propertyType,
                        onChanged: (v) => setState(() => propertyType = v!),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (v) => description = v ?? '',
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'House Rules',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (v) => houseRules = v ?? '',
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Navigate to Page2 and pass collected info
                        Navigator.pushNamed(
                          context,
                          AddPropertyPage2.routeName,
                          arguments: {
                            'name': propertyName,
                            'type': propertyType,
                            'description': description,
                            'rules': houseRules,
                          },
                        );
                      }
                    },
                    child: Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

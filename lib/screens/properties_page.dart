import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_property_page1.dart';
import 'edit_property_page.dart';

class PropertiesPage extends StatefulWidget {
  static const routeName = '/properties';

  @override
  _PropertiesPageState createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  // Navigate to Add Property page
  Future<void> _navigateToAddProperty() async {
    await Navigator.pushNamed(context, AddPropertyPage1.routeName);
    // StreamBuilder will auto-update, no manual update needed
  }

  // Navigate to Edit Property page
  Future<void> _navigateToEditProperty(
    Map<String, dynamic> property,
    String docId,
  ) async {
    final propertyWithId = Map<String, String>.from(
      property.map((key, value) => MapEntry(key, value?.toString() ?? '')),
    );
    propertyWithId['id'] = docId;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditPropertyPage(property: propertyWithId),
      ),
    );
    // Firestore updates automatically via StreamBuilder
  }

  // Confirm delete property
  void _confirmDelete(String propertyId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Property'),
        content: Text('Are you sure you want to delete this property?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('properties')
                  .doc(propertyId)
                  .delete();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Property deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) return Center(child: Text('User not found'));

    final propertiesStream = FirebaseFirestore.instance
        .collection('properties')
        .where('ownerId', isEqualTo: currentUser!.uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Properties',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search properties by Name or Location',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Properties list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: propertiesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No properties found'));
                  }

                  final docs = snapshot.data!.docs;

                  // Filter by search
                  final filteredDocs = docs.where((doc) {
                    final name = doc['name'].toString().toLowerCase();
                    final location = doc['location'].toString().toLowerCase();
                    return name.contains(searchQuery) ||
                        location.contains(searchQuery);
                  }).toList();

                  if (filteredDocs.isEmpty)
                    return Center(child: Text('No properties found'));

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (ctx, i) {
                      final docId = filteredDocs[i].id;
                      final p = filteredDocs[i].data() as Map<String, dynamic>;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              p['image'] ??
                                  'https://picsum.photos/200/140?random=1',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            p['name'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p['location'] ?? '',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      p['rating'] ?? '',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          trailing: PopupMenuButton(
                            onSelected: (value) {
                              if (value == 'edit')
                                _navigateToEditProperty(p, docId);
                              if (value == 'delete') _confirmDelete(docId);
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Color(0xFF004AAD)),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Add button
      floatingActionButton: ElevatedButton.icon(
        onPressed: _navigateToAddProperty,
        icon: Icon(Icons.add),
        label: Text('Add'),
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          backgroundColor: Color(0xFF004AAD),
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

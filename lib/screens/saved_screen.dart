// lib/screens/saved_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

/// SavedScreen works in two modes:
/// 1) Local mode: pass `savedItems` (List<Map<String,String>>) and `onRemove` callback.
///    Used by HomeScreen when using in-memory saved list.
/// 2) Firestore mode: don't pass savedItems/onRemove — it will stream
///    from users/{uid}/saved collection.
class SavedScreen extends StatelessWidget {
  final List<Map<String, String>>? savedItems;
  final void Function(Map<String, String>)? onRemove;

  const SavedScreen({Key? key, this.savedItems, this.onRemove})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If savedItems provided => use local mode
    if (savedItems != null) {
      return _buildLocalSaved(context, savedItems!, onRemove);
    }

    // Else use Firestore mode
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Saved')),
        body: const Center(child: Text('User not signed in')),
      );
    }

    final uid = currentUser.uid;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(selectedLocation: "YourLocation"),
              ),
            );
          },
        ),
        title: const Text("Saved"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("saved")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No saved items yet", style: TextStyle(fontSize: 18)),
            );
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final docId = doc.id;

              final item = <String, String>{
                'name': data['name']?.toString() ?? '',
                'location': data['location']?.toString() ?? '',
                'price': data['price']?.toString() ?? '',
                'image': data['image']?.toString() ?? '',
                'id': docId,
              };

              return _savedCard(
                context: context,
                data: item,
                onRemoveLocal: (_) async {
                  // Delete doc in firestore
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .collection("saved")
                      .doc(docId)
                      .delete();
                },
              );
            },
          );
        },
      ),
    );
  }

  // ---------- Local mode builder ----------
  Widget _buildLocalSaved(
    BuildContext context,
    List<Map<String, String>> list,
    void Function(Map<String, String>)? onRemove,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(selectedLocation: "YourLocation"),
              ),
            );
          },
        ),
        title: const Text("Saved"),
      ),
      body: list.isEmpty
          ? const Center(
              child: Text("No saved items yet", style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return _savedCard(
                  context: context,
                  data: item,
                  onRemoveLocal: (it) {
                    // call provided callback if exists, otherwise do nothing
                    if (onRemove != null) onRemove(it);
                  },
                );
              },
            ),
    );
  }

  // ---------- Reusable saved card ----------
  Widget _savedCard({
    required BuildContext context,
    required Map<String, String> data,
    required void Function(Map<String, String>) onRemoveLocal,
  }) {
    final imageUrl = data['image'] ?? '';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: (imageUrl.startsWith('http'))
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  )
                : Image.asset(
                    imageUrl.isEmpty
                        ? 'assets/profile_placeholder.png'
                        : imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),

          // TEXT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data['location'] ?? '',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['price'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // DELETE
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              onRemoveLocal({
                'name': data['name'] ?? '',
                'location': data['location'] ?? '',
                'price': data['price'] ?? '',
                'image': data['image'] ?? '',
                'id': data['id'] ?? '',
              });
            },
          ),
        ],
      ),
    );
  }
}

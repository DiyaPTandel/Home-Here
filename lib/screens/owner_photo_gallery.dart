import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OwnerPhotoGalleryPage extends StatefulWidget {
  final String propertyId;
  const OwnerPhotoGalleryPage({super.key, required this.propertyId});

  @override
  _OwnerPhotoGalleryPageState createState() => _OwnerPhotoGalleryPageState();
}

class _OwnerPhotoGalleryPageState extends State<OwnerPhotoGalleryPage> {
  List<String> photos = [];
  final ImagePicker _picker = ImagePicker();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  // Load photos from Firestore
  Future<void> _loadPhotos() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .get();

      if (snapshot.exists && snapshot.data()?['photos'] != null) {
        photos = List<String>.from(snapshot.data()?['photos']);
      }
    } catch (e) {
      debugPrint('Error loading photos: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Add new photo
  Future<void> _addPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => isLoading = true);

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = FirebaseStorage.instance
          .ref()
          .child('property_photos')
          .child(widget.propertyId)
          .child(fileName);

      await ref.putFile(File(image.path));
      final downloadUrl = await ref.getDownloadURL();

      photos.add(downloadUrl);
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .update({'photos': photos});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('Error adding photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add photo'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Delete a photo
  Future<void> _deletePhoto(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (!(confirm ?? false)) return;

    setState(() => isLoading = true);

    try {
      // Delete from Firebase Storage if it's a storage URL
      if (photos[index].startsWith('https://')) {
        final ref = FirebaseStorage.instance.refFromURL(photos[index]);
        await ref.delete();
      }

      photos.removeAt(index);
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(widget.propertyId)
          .update({'photos': photos});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo deleted'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      debugPrint('Error deleting photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete photo'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _viewPhoto(String photo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PhotoPreviewPage(photo: photo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Photos'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : photos.isEmpty
          ? const Center(
              child: Text(
                'No photos added yet',
                style: TextStyle(fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GestureDetector(
                    onTap: () => _viewPhoto(photo),
                    child: Stack(
                      children: [
                        Hero(
                          tag: photo,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                              image: DecorationImage(
                                image: photo.startsWith('http')
                                    ? NetworkImage(photo)
                                    : FileImage(File(photo)) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () => _deletePhoto(index),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPhoto,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add_a_photo, size: 28),
      ),
    );
  }
}

class PhotoPreviewPage extends StatelessWidget {
  final String photo;
  const PhotoPreviewPage({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: photo,
            child: photo.startsWith('http')
                ? Image.network(photo, fit: BoxFit.contain)
                : Image.file(File(photo), fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

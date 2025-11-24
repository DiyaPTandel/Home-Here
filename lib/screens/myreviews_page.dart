import 'package:flutter/material.dart';

class MyReviewsScreen extends StatefulWidget {
  final List<String> reviews;
  final Function(int, String?) onUpdate; // index and new text
  final Function(int) onDelete; // index

  const MyReviewsScreen({
    super.key,
    required this.reviews,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.reviews.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Reviews")),
        body: const Center(
          child: Text(
            "You haven't added any reviews yet.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Reviews")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.reviews.length,
        itemBuilder: (context, index) {
          final review = widget.reviews[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(review),
              leading: const Icon(Icons.rate_review),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit button
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final updated = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          final controller = TextEditingController(
                            text: review,
                          );
                          return AlertDialog(
                            title: const Text("Edit Review"),
                            content: TextField(
                              controller: controller,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                hintText: "Enter your review",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, null),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(context, controller.text),
                                child: const Text("Save"),
                              ),
                            ],
                          );
                        },
                      );

                      if (updated != null && updated.isNotEmpty) {
                        widget.onUpdate(index, updated);
                        setState(() {});
                      }
                    },
                  ),
                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      widget.onDelete(index);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

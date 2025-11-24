import 'package:flutter/material.dart';
import 'home_screen.dart';

class UserReviewsPage extends StatefulWidget {
  final String userEmail;

  const UserReviewsPage({super.key, required this.userEmail});

  @override
  State<UserReviewsPage> createState() => _UserReviewsPageState();
}

class _UserReviewsPageState extends State<UserReviewsPage> {
  // Sample data – in real app, fetch from DB or API using userEmail
  List<Map<String, dynamic>> userReviews = [
    {
      "hostelName": "Greenwood PG",
      "rating": 4,
      "comment": "Very clean and friendly staff!",
    },
    {
      "hostelName": "Sunrise Hostel",
      "rating": 5,
      "comment": "Great location and comfortable rooms.",
    },
  ];

  void _removeReview(int index) {
    setState(() {
      userReviews.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Review removed successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reviews"),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),
      body: userReviews.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.reviews_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "You haven't reviewed any hostels yet",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Go back to HomeScreen (or HomePage) with last location
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            selectedLocation: "Delhi",
                          ), // pass real location dynamically if needed
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Explore Hostels",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: userReviews.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final review = userReviews[index];
                return ListTile(
                  title: Text(review['hostelName']),
                  subtitle: Text(review['comment']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Rating stars
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < review['rating']
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Delete icon
                      GestureDetector(
                        onTap: () => _removeReview(index),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

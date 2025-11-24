import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'gallery_page.dart';
import 'reserve_page.dart';
import 'review_page.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> hostelData;

  const DetailsPage({super.key, required this.hostelData});

  @override
  Widget build(BuildContext context) {
    // Images list
    final images = hostelData["photos"] != null
        ? List<String>.from(hostelData["photos"].map((e) => e.toString()))
        : [hostelData["image"]?.toString() ?? "assets/profile_placeholder.png"];

    // Reviews list
    final reviews = hostelData["reviews"] != null
        ? List<Map<String, dynamic>>.from(hostelData["reviews"])
        : [
            {
              "name": "Priya Sharma",
              "time": "2 weeks ago",
              "review":
                  "Amazing place! Very clean and the owner is super helpful. Would definitely recommend to other students.",
            },
            {
              "name": "Sneha Patel",
              "time": "4 weeks ago",
              "review":
                  "Good location near universities. WiFi is excellent and food quality is nice.",
            },
            {
              "name": "Rahul Kumar",
              "time": "4 weeks ago",
              "review":
                  "Comfortable stay with good amenities. The common area is well maintained.",
            },
          ];

    // Owner info
    final owner = hostelData["owner"] != null
        ? Map<String, dynamic>.from(hostelData["owner"])
        : {
            "name": "Mr. Suresh Reddy",
            "phone": "+91 98765 43210",
            "designation": "Property Owner",
          };

    // House rules
    final houseRules = hostelData["rulesList"] != null
        ? List<String>.from(hostelData["rulesList"].map((e) => e.toString()))
        : [
            "Check-in: 10:00 AM – 6:00 PM",
            "Visitors allowed until 8:00 PM",
            "No smoking inside premises",
            "Maintain cleanliness in common areas",
          ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Image + back button + gallery + category badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    child: _buildImage(images.first),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(
                          Icons.photo_library,
                          color: Color(0xFF1976D2),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GalleryPage(images: images),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getCategoryFromName(
                          hostelData["name"]?.toString() ?? "",
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            hostelData["name"]?.toString() ?? "Unknown",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          hostelData["price"]?.toString() ?? "N/A",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Location + Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hostelData["location"]?.toString() ??
                              "Unknown location",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 2),
                        Text(
                          reviews.length.toString(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // About
                    const Text(
                      "About",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      hostelData["description"]?.toString() ??
                          "No description available.",
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Reviews
                    Text(
                      "Reviews (${reviews.length})",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...reviews.map(
                      (r) => Column(
                        children: [
                          _buildReview(
                            name: r["name"]?.toString() ?? "Anonymous",
                            time: r["time"]?.toString() ?? "",
                            review: r["review"]?.toString() ?? "",
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),

                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Color(0xFF1976D2)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ReviewPage()),
                        );
                      },
                      icon: const Icon(Icons.edit, color: Color(0xFF1976D2)),
                      label: const Text(
                        "Write a review",
                        style: TextStyle(color: Color(0xFF1976D2)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Contact Owner
                    const Text(
                      "Contact Owner",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFF1976D2),
                                child: Text(
                                  (owner["name"]?.toString() ?? "O")[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                owner["name"]?.toString() ?? "Owner",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                owner["designation"]?.toString() ??
                                    "Property Owner",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.call,
                                size: 20,
                                color: Colors.black87,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                owner["phone"]?.toString() ?? "+91 00000 00000",
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Image.asset(
                                'assets/whatsapp.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                owner["phone"]?.toString() ?? "+91 00000 00000",
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ReservePage(hostelData: hostelData),
                                ),
                              );
                            },
                            child: const Center(
                              child: Text(
                                "Request for Visit",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // House Rules
                    const Text(
                      "House Rules",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...houseRules.map((rule) => Text("• $rule")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryFromName(String name) {
    final lower = name.toLowerCase();
    if (lower.contains("pg")) return "PG";
    if (lower.contains("hostel")) return "Hostel";
    if (lower.contains("flat")) return "Flat";
    return "Stay";
  }

  Widget _buildReview({
    required String name,
    required String time,
    required String review,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            name[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(time, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(
                  5,
                  (index) =>
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                ),
              ),
              const SizedBox(height: 4),
              Text(review),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith("http")) {
      return CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: double.infinity,
          height: 220,
          color: Colors.grey[300],
        ),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: 220,
          color: Colors.grey[300],
          child: const Icon(Icons.image_not_supported),
        ),
      );
    } else {
      return Image.asset(
        url,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      );
    }
  }
}

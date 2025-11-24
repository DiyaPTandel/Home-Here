import 'package:flutter/material.dart';
import 'details.dart';

class PgPage extends StatelessWidget {
  final List<Map<String, String>> pgs;
  final List<Map<String, String>> savedPgs;
  final Function(Map<String, String>) onToggleFavorite;

  const PgPage({
    super.key,
    required this.pgs,
    required this.savedPgs,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> displayPgs = pgs.isNotEmpty
        ? pgs
        : [
            {
              "name": "Shreenath PG",
              "location": "Vastrapur, Ahmedabad",
              "price": "₹6,000/month",
              "image":
                  "https://images.unsplash.com/photo-1570129477492-45c003edd2be", // web image
              "description": "Clean rooms, Wi-Fi, and meals included.",
            },
            {
              "name": "UrbanNest PG",
              "location": "Maninagar, Ahmedabad",
              "price": "₹7,500/month",
              "image":
                  "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
              "description": "Study-friendly environment with AC rooms.",
            },
            {
              "name": "Royal Residency PG",
              "location": "Alkapuri, Ahmedabad",
              "price": "₹6,500/month",
              "image":
                  "https://images.unsplash.com/photo-1599423300746-b62533397364",
              "description": "Near metro and shopping areas.",
            },
          ];

    return Scaffold(
      appBar: AppBar(title: const Text("PGs in Gujarat")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWideScreen ? 3 : 1,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: isWideScreen ? 1.4 : 2.5, // fix overflow
            ),
            itemCount: displayPgs.length,
            itemBuilder: (context, index) {
              final pg = displayPgs[index];
              final isSaved = savedPgs.contains(pg);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(hostelData: pg),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(16),
                        ),
                        child: Image.network(
                          pg["image"]!,
                          width: isWideScreen ? 180 : 120,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              width: isWideScreen ? 180 : 120,
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pg["name"]!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis, // prevent overflow
                              ),
                              Text(
                                pg["location"]!,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                pg["price"]!,
                                style: const TextStyle(
                                  color: Color(0xFF1976D2),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: Icon(
                                    isSaved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                  ),
                                  color: isSaved
                                      ? const Color(0xFF1976D2)
                                      : null,
                                  onPressed: () => onToggleFavorite(pg),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}

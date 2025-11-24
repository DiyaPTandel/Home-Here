import 'package:flutter/material.dart';
import 'details.dart';

class FlatPage extends StatelessWidget {
  final List<Map<String, String>> flats;
  final List<Map<String, String>> savedFlats;
  final Function(Map<String, String>) onToggleFavorite;

  const FlatPage({
    super.key,
    required this.flats,
    required this.savedFlats,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> displayFlats = flats.isNotEmpty
        ? flats
        : [
            {
              "name": "Shree Residency Flat",
              "location": "Vastrapur, Ahmedabad, Gujarat",
              "price": "₹12,000/month",
              "image":
                  "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
              "description": "Spacious and modern flat with all amenities.",
            },
            {
              "name": "Urban Residency",
              "location": "Maninagar, Ahmedabad, Gujarat",
              "price": "₹11,500/month",
              "image":
                  "https://images.unsplash.com/photo-1570129477492-45c003edd2be",
              "description": "Cozy flat near markets and transport.",
            },
            {
              "name": "Elite Residency",
              "location": "Navrangpura, Ahmedabad, Gujarat",
              "price": "₹13,000/month",
              "image":
                  "https://images.unsplash.com/photo-1599423300746-b62533397364",
              "description": "Premium flat with parking and security.",
            },
          ];

    return Scaffold(
      appBar: AppBar(title: const Text("Flats")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWideScreen ? 3 : 1,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: isWideScreen ? 1.4 : 2.5,
            ),
            itemCount: displayFlats.length,
            itemBuilder: (context, index) {
              final flat = displayFlats[index];
              final isSaved = savedFlats.contains(flat);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(hostelData: flat),
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
                          flat["image"]!,
                          width: isWideScreen ? 180 : 120,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              width: isWideScreen ? 180 : 120,
                              child:
                                  const Icon(Icons.image_not_supported),
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
                                flat["name"]!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                flat["location"]!,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                flat["price"]!,
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
                                  onPressed: () => onToggleFavorite(flat),
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

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'details.dart';

class HostelPage extends StatefulWidget {
  final List<Map<String, String>> hostels;
  final List<Map<String, String>> savedHostels;
  final Function(Map<String, String>) onToggleFavorite;

  const HostelPage({
    super.key,
    required this.hostels,
    required this.savedHostels,
    required this.onToggleFavorite,
  });

  @override
  _HostelPageState createState() => _HostelPageState();
}

class _HostelPageState extends State<HostelPage> {
  late List<Map<String, String>> displayHostels;

  @override
  void initState() {
    super.initState();
    displayHostels = widget.hostels.isNotEmpty
        ? widget.hostels
        : [
            {
              "name": "GreenNest Hostel",
              "location": "Vastrapur, Ahmedabad",
              "price": "₹79,000/year",
              "image":
                  "https://images.unsplash.com/photo-1599423300746-b62533397364",
              "description": "Spacious rooms, free Wi-Fi, and attached washrooms.",
            },
            {
              "name": "City View Residency",
              "location": "Maninagar, Ahmedabad",
              "price": "₹85,500/year",
              "image":
                  "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
              "description": "Modern hostel with rooftop café and easy access to city.",
            },
          ];
  }

  void toggleFavorite(Map<String, String> hostel) {
    setState(() {
      widget.onToggleFavorite(hostel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hostels")),
      body: displayHostels.isEmpty
          ? const Center(child: Text("No hostels available"))
          : LayoutBuilder(
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
                  itemCount: displayHostels.length,
                  itemBuilder: (context, index) {
                    final hostel = displayHostels[index];
                    final isSaved = widget.savedHostels.contains(hostel);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsPage(hostelData: hostel),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                // Image Section
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(16)),
                                  child: CachedNetworkImage(
                                    imageUrl: hostel["image"]!,
                                    width: isWideScreen ? 180 : 100,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(color: Colors.grey[300]),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                          Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                // Info Section
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hostel["name"]!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          hostel["location"]!,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          hostel["price"]!,
                                          style: const TextStyle(
                                            color: Color(0xFF1976D2),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Saved Icon at top-right
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: Icon(
                                  isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                ),
                                color: isSaved ? const Color(0xFF1976D2) : null,
                                onPressed: () => toggleFavorite(hostel),
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

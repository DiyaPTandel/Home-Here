import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'saved_screen.dart';
import 'details.dart';
import 'hostel_page.dart';
import 'pg_page.dart';
import 'flat_page.dart';
import 'select_location_screen.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;
  final List<Map<String, String>> items;
  final List<Map<String, String>> savedItems;
  final Function(Map<String, String>) onToggleFavorite;

  const CategoryPage({
    super.key,
    required this.categoryName,
    required this.items,
    required this.savedItems,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: items.isEmpty
          ? const Center(child: Text("No items found"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSaved = savedItems.any(
                  (saved) => saved["name"] == item["name"],
                ); // FIXED

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(hostelData: item),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      leading: Image.asset(
                        item["image"]!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item["name"]!),
                      subtitle: Text("${item["location"]!}\n${item["price"]!}"),
                      trailing: IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                        ),
                        color: isSaved ? const Color(0xFF1976D2) : null,
                        onPressed: () => onToggleFavorite(item),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String selectedLocation;

  const HomeScreen({super.key, required this.selectedLocation});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, String>> _savedHostels = [];

  // Sample data
  final List<Map<String, String>> _allHostels = [
    {
      "name": "Greenwood PG",
      "location": "Navrangpura, Ahmedabad",
      "price": "₹5500/month",
      "image": "assets/hostel3.png",
      "reviews": "4.3 (85 reviews)",
    },
    {
      "name": "Greenland Hostel",
      "location": "Prahlad Nagar, Ahmedabad",
      "price": "₹6500/month",
      "image": "assets/hostel1.png",
      "reviews": "4.6 (110 reviews)",
    },
    {
      "name": "Cozy Nest Flats",
      "location": "Thaltej, Ahmedabad",
      "price": "₹5200/month",
      "image": "assets/hostel2.png",
      "reviews": "4.4 (70 reviews)",
    },
  ];

  List<Map<String, String>> _filteredHostels = [];
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> topCategories = [
    {"name": "Hostel", "icon": Icons.home},
    {"name": "PG", "icon": Icons.apartment},
    {"name": "Flats", "icon": Icons.house},
  ];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _filteredHostels = List.from(_allHostels);

    _pages = [
      const SizedBox(), // Home placeholder
      SavedScreen(savedItems: _savedHostels, onRemove: _removeSaved),
      const Center(child: Text("Maps Page")),
      const ProfilePage(),
    ];
  }

  // ----------------------------------------------------------
  // 🔥 FIXED: Reliable saved check using name as unique ID
  // ----------------------------------------------------------
  bool _isSaved(Map<String, String> hostel) {
    return _savedHostels.any((item) => item["name"] == hostel["name"]);
  }

  // ----------------------------------------------------------
  // 🔥 FIXED: Toggle favorite correctly (no more .contains())
  // ----------------------------------------------------------
  void _toggleFavorite(Map<String, String> hostel) {
    setState(() {
      final exists = _isSaved(hostel);

      if (exists) {
        _savedHostels.removeWhere((item) => item["name"] == hostel["name"]);
      } else {
        _savedHostels.add(hostel);
      }

      _pages[1] = SavedScreen(
        savedItems: _savedHostels,
        onRemove: _removeSaved,
      );
    });
  }

  // ----------------------------------------------------------
  // 🔥 FIXED: Remove saved item correctly
  // ----------------------------------------------------------
  void _removeSaved(Map<String, String> hostel) {
    setState(() {
      _savedHostels.removeWhere((item) => item["name"] == hostel["name"]);

      _pages[1] = SavedScreen(
        savedItems: _savedHostels,
        onRemove: _removeSaved,
      );
    });
  }

  // ----------------------------------------------------------
  // Filters
  // ----------------------------------------------------------
  void _filterHostels(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHostels = List.from(_allHostels);
      } else {
        _filteredHostels = _allHostels.where((hostel) {
          final search = query.toLowerCase();
          return hostel["name"]!.toLowerCase().contains(search) ||
              hostel["location"]!.toLowerCase().contains(search);
        }).toList();
      }
    });
  }

  String _getCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains("pg")) return "PG";
    if (lower.contains("hostel")) return "Hostel";
    if (lower.contains("flat")) return "Flat";
    return "Stay";
  }

  // ----------------------------------------------------------
  // HOME CONTENT
  // ----------------------------------------------------------
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectLocationScreen(),
                ),
              );
            },
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                Text(
                  "Current Location: ${widget.selectedLocation}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Categories Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: topCategories.length,
            itemBuilder: (context, index) {
              final category = topCategories[index];
              return GestureDetector(
                onTap: () {
                  if (category["name"] == "Hostel") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HostelPage(
                          hostels: const [],
                          savedHostels: _savedHostels,
                          onToggleFavorite: _toggleFavorite,
                        ),
                      ),
                    );
                  } else if (category["name"] == "PG") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PgPage(
                          pgs: const [],
                          savedPgs: _savedHostels,
                          onToggleFavorite: _toggleFavorite,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlatPage(
                          flats: const [],
                          savedFlats: _savedHostels,
                          onToggleFavorite: _toggleFavorite,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(category["icon"], size: 36, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        category["name"],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Search
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search for PGs, Hostels, Flats...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: _filterHostels,
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFFFC107)),
              const SizedBox(width: 6),
              Text(
                'Top Rated in "${widget.selectedLocation}"',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Hostel Cards
          ..._filteredHostels.map((hostel) {
            final isSaved = _isSaved(hostel);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(hostelData: hostel),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                            hostel["image"]!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1976D2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _getCategory(hostel["name"]!),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hostel["name"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hostel["location"]!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hostel["price"]!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Color(0xFFFFC107),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  hostel["reviews"]!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () => _toggleFavorite(hostel),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? const Color(0xFF1976D2) : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 ? _buildHomeContent() : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1976D2),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Saved"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Maps"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

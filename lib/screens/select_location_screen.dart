import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'home_screen.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  final List<String> _allCities = [
    "Ahmedabad",
    "Surat",
    "Vadodara",
    "Rajkot",
    "Bhavnagar",
    "Jamnagar",
    "Junagadh",
    "Gandhinagar",
    "Vapi",
    "Anand",
    "Navsari",
    "Morbi",
    "Bharuch",
    "Mehsana",
    "Porbandar",
    "Nadiad",
    "Patan",
    "Surendranagar",
    "Veraval",
  ];

  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredCities = _allCities
          .where((city) => city.toLowerCase().contains(query))
          .toList();
    });
  }

  void _navigateToHome(String location) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(selectedLocation: location),
      ),
    );
  }

  void _searchLocation() {
    final input = _searchController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a location to search")),
      );
      return;
    }
    if (!_allCities.map((c) => c.toLowerCase()).contains(input.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a city within Gujarat")),
      );
      return;
    }
    _navigateToHome(input);
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Location permission permanently denied. Enable it in settings.",
            ),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String? city = placemarks.first.locality;

      if (city == null ||
          !_allCities
              .map((c) => c.toLowerCase())
              .contains(city.toLowerCase())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Your location is outside Gujarat.")),
        );
        setState(() => _isLoading = false);
        return;
      }

      _navigateToHome(city);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching location: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizes
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.05;
    final double spacing = screenHeight * 0.02;
    final double titleSize = screenWidth * 0.06;
    final double textSize = screenWidth * 0.04;
    final double buttonHeight = screenHeight * 0.06;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: spacing / 2,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Select Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(padding),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose your preferred location in Gujarat to find hostels and PGs nearby.",
                          style: TextStyle(
                            fontSize: textSize,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: spacing),

                        // 🔍 Search field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(fontSize: textSize),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.blue,
                              ),
                              hintText: "Search for a city in Gujarat",
                              hintStyle: TextStyle(fontSize: textSize),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: padding,
                                vertical: spacing * 0.7,
                              ),
                            ),
                          ),
                        ),

                        if (_filteredCities.isNotEmpty) ...[
                          SizedBox(height: spacing / 2),
                          Container(
                            height: screenHeight * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ListView.builder(
                              itemCount: _filteredCities.length,
                              itemBuilder: (context, index) {
                                final city = _filteredCities[index];
                                return ListTile(
                                  title: Text(
                                    city,
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  leading: const Icon(
                                    Icons.location_city,
                                    color: Colors.blue,
                                  ),
                                  onTap: () => _navigateToHome(city),
                                );
                              },
                            ),
                          ),
                        ],

                        SizedBox(height: spacing),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            minimumSize: Size(double.infinity, buttonHeight),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _searchLocation,
                          child: Text(
                            "Search Location",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: textSize,
                            ),
                          ),
                        ),

                        SizedBox(height: spacing / 2),
                        OutlinedButton.icon(
                          icon: _isLoading
                              ? SizedBox(
                                  width: textSize,
                                  height: textSize,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.blue,
                                  ),
                                )
                              : const Icon(
                                  Icons.my_location,
                                  color: Colors.blue,
                                ),
                          label: Text(
                            _isLoading
                                ? "Fetching Location..."
                                : "Use My Current Location",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: textSize,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, buttonHeight),
                            side: const BorderSide(color: Colors.blue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _isLoading ? null : _useCurrentLocation,
                        ),

                        SizedBox(height: spacing * 1.2),
                        Text(
                          "Popular Locations (Gujarat)",
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: spacing / 2),

                        _buildPopularLocation("Ahmedabad", textSize),
                        _buildPopularLocation("Surat", textSize),
                        _buildPopularLocation("Vadodara", textSize),
                        _buildPopularLocation("Rajkot", textSize),
                        _buildPopularLocation("Gandhinagar", textSize),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularLocation(String location, double textSize) {
    return InkWell(
      onTap: () => _navigateToHome(location),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(textSize * 0.9),
        margin: EdgeInsets.only(bottom: textSize * 0.8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue),
            SizedBox(width: textSize * 0.8),
            Expanded(
              child: Text(
                location,
                style: TextStyle(fontSize: textSize, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

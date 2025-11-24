import 'package:flutter/material.dart';

class VisitInfoPage extends StatelessWidget {
  final String userEmail;

  const VisitInfoPage({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    // Sample visit requests – in a real app, fetch from DB/API using userEmail
    final List<Map<String, String>> visitRequests = [
      {
        "propertyName": "Greenwood PG",
        "ownerName": "Mr. Sharma",
        "date": "10 Oct 2025",
        "time": "11:00 AM",
        "status": "Pending",
      },
      {
        "propertyName": "Sunrise Hostel",
        "ownerName": "Ms. Anita",
        "date": "12 Oct 2025",
        "time": "3:00 PM",
        "status": "Accepted",
      },
      {
        "propertyName": "Comfort Stay Flat",
        "ownerName": "Mr. Rakesh",
        "date": "15 Oct 2025",
        "time": "5:30 PM",
        "status": "Rejected",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Visit Info"),
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: true,
      ),
      body: visitRequests.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info_outline, size: 80, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    "No visit requests sent yet",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to Home
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
                      "Explore Properties",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: visitRequests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final request = visitRequests[index];
                Color statusColor;
                switch (request['status']) {
                  case 'Accepted':
                    statusColor = Colors.green;
                    break;
                  case 'Rejected':
                    statusColor = Colors.red;
                    break;
                  default:
                    statusColor = Colors.orange;
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request['propertyName']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Owner: ${request['ownerName']!}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Date: ${request['date']!} | Time: ${request['time']!}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                request['status']!,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Implement delete functionality if needed
                              },
                            ),
                          ],
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'visit_requests_page.dart';
import 'properties_page.dart';
import 'owner_profile_page.dart';

class OwnerDashboard extends StatefulWidget {
  static const routeName = '/owner_dashboard';

  @override
  _OwnerDashboardState createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  int _currentIndex = 0;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      DashboardHomePageStream(
        onNavigate: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      PropertiesPage(),
      VisitRequestsPage(),
      OwnerProfilePage(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _currentIndex == 0
            ? AppBar(title: Text('Owner Dashboard'), centerTitle: true)
            : null,
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Properties',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              label: 'Requests',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    } else {
      final exit = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('Exit'),
            ),
          ],
        ),
      );
      return exit ?? false;
    }
  }
}

// ---------------- Dashboard Home Page (Stream-based) ----------------
class DashboardHomePageStream extends StatelessWidget {
  final Function(int)? onNavigate;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  DashboardHomePageStream({this.onNavigate});

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) return Center(child: Text("User not found"));

    String uid = currentUser!.uid;

    // Streams for properties and visit requests
    final propertiesStream = FirebaseFirestore.instance
        .collection('properties')
        .where('ownerId', isEqualTo: uid)
        .snapshots();

    final requestsStream = FirebaseFirestore.instance
        .collection('visitRequests')
        .where('ownerId', isEqualTo: uid)
        .orderBy('date', descending: true)
        .limit(5)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: propertiesStream,
      builder: (context, propSnapshot) {
        if (propSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        int propertyCount = propSnapshot.data?.docs.length ?? 0;

        return StreamBuilder<QuerySnapshot>(
          stream: requestsStream,
          builder: (context, reqSnapshot) {
            if (reqSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            int visitRequestCount = reqSnapshot.data?.docs.length ?? 0;
            List<Map<String, dynamic>> recentRequests = reqSnapshot.data!.docs
                .map((doc) {
                  return {
                    "name": doc['tenantName'],
                    "property": doc['propertyName'],
                    "date": doc['date'].toDate(),
                    "status": doc['status'],
                  };
                })
                .toList();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onNavigate?.call(1),
                          child: Card(
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: 36,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Properties',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '$propertyCount',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onNavigate?.call(2),
                          child: Card(
                            color: Colors.green[50],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_add_alt_1,
                                    size: 36,
                                    color: Colors.green,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Visit Requests',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '$visitRequestCount',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Requests',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => onNavigate?.call(2),
                        child: Text('View All'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: recentRequests.isEmpty
                        ? Center(child: Text('No recent requests'))
                        : ListView.builder(
                            itemCount: recentRequests.length,
                            itemBuilder: (_, index) {
                              final req = recentRequests[index];
                              Color bgColor;
                              switch (req['status']) {
                                case 'Accepted':
                                  bgColor = Colors.green[50]!;
                                  break;
                                case 'Pending':
                                  bgColor = Colors.orange[50]!;
                                  break;
                                default:
                                  bgColor = Colors.red[50]!;
                              }
                              final date = req['date'] as DateTime;
                              final formattedDate =
                                  "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(req['name'][0]),
                                ),
                                title: Text(req['name']),
                                subtitle: Text(
                                  '${req['property']}\nDate: $formattedDate',
                                ),
                                trailing: Chip(
                                  label: Text(req['status']),
                                  backgroundColor: bgColor,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

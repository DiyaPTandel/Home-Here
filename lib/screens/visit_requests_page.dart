import 'package:flutter/material.dart';

class VisitRequestsPage extends StatefulWidget {
  static const routeName = '/visit_requests';

  @override
  _VisitRequestsPageState createState() => _VisitRequestsPageState();
}

class _VisitRequestsPageState extends State<VisitRequestsPage> {
  List<Map<String, String>> requests = [
    {
      'name': 'Piya Tandel',
      'hostel': 'Celestia Living Girls Hostel',
      'date': '08/17/2025',
      'status': 'Pending',
    },
    {
      'name': 'Fairy Patel',
      'hostel': 'Celestia Living Girls Hostel',
      'date': '09/17/2025',
      'status': 'Pending',
    },
    {
      'name': 'Tej Patel',
      'hostel': 'Vistara PG',
      'date': '09/17/2025',
      'status': 'Pending',
    },
    {
      'name': 'Mina Sharma',
      'hostel': 'Shivangi Girls Hostel',
      'date': '08/15/2025',
      'status': 'Accepted',
    },
  ];

  void _acceptRequest(int index) async {
    final request = requests[index];

    bool confirmed = await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Accept Request'),
            content: Text(
                'Are you sure you want to accept the visit request from ${request['name']}?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel')),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Accept')),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      setState(() {
        requests[index]['status'] = 'Accepted';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Accepted request from ${request['name']}')),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _declineRequest(int index) async {
    final request = requests[index];

    bool confirmed = await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Decline Request'),
            content: Text(
                'Are you sure you want to decline the visit request from ${request['name']}?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel')),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Decline')),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      setState(() {
        requests[index]['status'] = 'Declined';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.cancel, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Declined request from ${request['name']}')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visit Requests'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: requests.isEmpty
            ? Center(child: Text('No visit requests available.'))
            : ListView.builder(
                itemCount: requests.length,
                itemBuilder: (ctx, i) {
                  final r = requests[i];
                  bool isAccepted = r['status'] == 'Accepted';
                  bool isDeclined = r['status'] == 'Declined';
                  bool isPending = r['status'] == 'Pending';

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(r['name']!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isAccepted
                                      ? Colors.green[100]
                                      : isDeclined
                                          ? Colors.red[100]
                                          : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  r['status']!,
                                  style: TextStyle(
                                      color: isAccepted
                                          ? Colors.green[800]
                                          : isDeclined
                                              ? Colors.red[800]
                                              : Colors.orange[800],
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(r['hostel']!, style: TextStyle(fontSize: 14)),
                          SizedBox(height: 6),
                          Text('Date: ${r['date']}', style: TextStyle(fontSize: 14)),
                          SizedBox(height: 12),
                          if (isPending)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _acceptRequest(i),
                                    child: Text('Accept'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8))),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _declineRequest(i),
                                    child: Text('Decline'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8))),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

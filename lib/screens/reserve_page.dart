import 'package:flutter/material.dart';
import 'reserved_page.dart';

class ReservePage extends StatefulWidget {
  final Map<String, dynamic> hostelData; // ✅ Changed to dynamic

  const ReservePage({Key? key, required this.hostelData}) : super(key: key);

  @override
  _ReservePageState createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  DateTime? _selectedDate;
  String _roomType = "2 Sharing";

  void _submitReservation() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ReservedPage()),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request for Visit"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hostel info card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.hostelData["image"]?.toString() ??
                        "assets/profile_placeholder.png",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(widget.hostelData["name"]?.toString() ?? "Unknown"),
                subtitle: Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(widget.hostelData["reviews"]?.toString() ?? "0"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Visiting date",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 254, 254),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _selectedDate == null
                      ? "Select Date"
                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Choose Room type",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("2 Sharing"),
                    value: "2 Sharing",
                    groupValue: _roomType,
                    onChanged: (value) =>
                        setState(() => _roomType = value.toString()),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("4 Sharing"),
                    value: "4 Sharing",
                    groupValue: _roomType,
                    onChanged: (value) =>
                        setState(() => _roomType = value.toString()),
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submitReservation,
              child: const Text("Request to reserve"),
            ),
          ],
        ),
      ),
    );
  }
}

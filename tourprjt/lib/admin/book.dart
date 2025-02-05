
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class Userbookings extends StatefulWidget {
  const Userbookings({super.key});

  @override
  State<Userbookings> createState() => _UserbookingsState();
}

class _UserbookingsState extends State<Userbookings> {
  Box? bookingBox;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    bookingBox = await Hive.openBox('bookingBox');
    setState(() {});
  }

  void _callUser(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone call')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bookingBox != null && bookingBox!.isOpen && bookingBox!.isNotEmpty
          ? ListView.builder(
              itemCount: bookingBox!.length,
              itemBuilder: (context, index) {
                var booking = bookingBox!.getAt(index);
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(booking['packageName'] ?? 'Unknown Package',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${booking['name']}"),
                        Text("People: ${booking['people']}"),
                        Text("Phone: ${booking['phone']}"),
                        Text("Place: ${booking['place']}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () => _callUser(booking['phone']),
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text("No bookings found.")),
    );
  }
}
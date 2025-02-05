import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tourprjt/user/home.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  late Box bookingBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    bookingBox = await Hive.openBox('bookingBox');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2596be),
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        title: const Text("Bookings"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff2596be),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ],
        ),
      ),
      body: bookingBox.isOpen && bookingBox.isNotEmpty
          ? ListView.builder(
              itemCount: bookingBox.length,
              itemBuilder: (context, index) {
                var booking = bookingBox.getAt(index);
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(booking['packageName'] ?? 'Unknown Package',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Name: ${booking['name']}"),
                  ),
                );
              },
            )
          : const Center(child: Text("No bookings found.")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set to 1 for Bookings screen
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
        ],
      ),
    );
  }
}

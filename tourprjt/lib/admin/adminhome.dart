import 'package:flutter/material.dart';
import 'package:tourprjt/admin/ahome.dart';
import 'package:tourprjt/admin/book.dart';
import 'package:tourprjt/admin/pakages.dart';
import 'package:tourprjt/user/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Adminhome(),
    PackagesPage(),
    Userbookings()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2596be),
          foregroundColor: Colors.white,
        title: const Text('Admin Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Remove const here!
            const DrawerHeader(
              decoration: BoxDecoration(
                color:Color(0xff2596be),
              ),
              child: Text(
                'Your App Name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('View Bookings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to the bookings page:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Userbookings())); // Example navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Packages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_add),
            label: 'bookings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

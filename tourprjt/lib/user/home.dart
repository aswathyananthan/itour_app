import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tourprjt/user/bookings.dart';
import 'package:tourprjt/user/login.dart';
import 'package:tourprjt/user/package.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Box tourBox;
  late Box eventBox;
  late Box concertBox;
  bool _boxesInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeHiveBoxes();
  }

  Future<void> _initializeHiveBoxes() async {
    tourBox = await Hive.openBox('tourBox');
    eventBox = await Hive.openBox('eventBox');
    concertBox = await Hive.openBox('concertBox');
    setState(() {
      _boxesInitialized = true;
    });
  }

  Widget _buildPackageList(Box box) {
    if (!_boxesInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (box.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No items available.'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: box.length,
      itemBuilder: (context, index) {
        final package = box.getAt(index) as Map;
        return Card(
          child: Column(
            children: [
              ListTile(
                leading: package['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          File(package['image']!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image),
                        ),
                      )
                    : const Icon(Icons.image),
                title: Text(
                  package['packageName'] ??
                      package['eventName'] ??
                      package['concertName'] ??
                      'Untitled',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (package['description'] != null &&
                        package['description'].toString().isNotEmpty)
                      Text(package['description']),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            package['company name'] ?? package['place'] ?? 'Location not specified',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          package['date'] ?? 'Date not specified',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${package['price'] ?? package['pricePerHead'] ?? 'Price not specified'}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2596be),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PackageDetail(package: package),
                    ),
                  );
                },
                child: const Text('Book Now',style: TextStyle(color:Colors.white),),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          title: const Text("Let's explore..!!"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.card_travel), text: "Tour Packages"),
              Tab(icon: Icon(Icons.event), text: "Events"),
              Tab(icon: Icon(Icons.music_note), text: "Concerts"),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
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
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Bookings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
             ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login())); // Close the drawer
              },
            ),
          ],
        ),
        ),
        body: TabBarView(
          children: [
            ValueListenableBuilder(
              valueListenable: tourBox.listenable(),
              builder: (context, box, _) => _buildPackageList(tourBox),
            ),
            ValueListenableBuilder(
              valueListenable: eventBox.listenable(),
              builder: (context, box, _) => _buildPackageList(eventBox),
            ),
            ValueListenableBuilder(
              valueListenable: concertBox.listenable(),
              builder: (context, box, _) => _buildPackageList(concertBox),
            ),
          ],
        ),
         bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (int index) {
            if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Bookings()),
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
      ),
    );
  }
}

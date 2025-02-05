// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:tourprjt/user/bookings.dart';

// class PackageDetail extends StatelessWidget {
//   final Map package;

//   const PackageDetail({super.key, required this.package});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(package['packageName'] ?? package['eventName'] ?? package['concertName'] ?? 'Package Details'),
//         backgroundColor: const Color(0xff2596be),
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (package['image'] != null)
//               Center(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.file(
//                     File(package['image']!),
//                     width: double.infinity,
//                     height: 200,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 100),
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 16),
//             Text(
//               package['packageName'] ?? package['eventName'] ?? package['concertName'] ?? 'Untitled',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             if (package['description'] != null && package['description'].toString().isNotEmpty)
//               Text(package['description'], style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 const Icon(Icons.location_on, size: 20),
//                 const SizedBox(width: 8),
//                 Text(package['company name'] ?? package['place'] ?? 'Location not specified',
//                     style: const TextStyle(fontSize: 16)),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Icon(Icons.calendar_today, size: 20),
//                 const SizedBox(width: 8),
//                 Text(package['date'] ?? 'Date not specified', style: const TextStyle(fontSize: 16)),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Icon(Icons.attach_money, size: 20),
//                 const SizedBox(width: 8),
//                 Text('${package['price'] ?? package['pricePerHead'] ?? 'Price not specified'}',
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//               ],
//             ),
//             const SizedBox(height: 24),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const Bookings()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff2596be),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 ),
//                 child: const Text('Proceed to Book'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class PackageDetail extends StatefulWidget {
  final Map package;

  const PackageDetail({super.key, required this.package});

  @override
  _PackageDetailState createState() => _PackageDetailState();
}

class _PackageDetailState extends State<PackageDetail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  Future<void> _confirmBooking() async {
    if (_formKey.currentState!.validate()) {
      var bookingBox = await Hive.openBox('bookingBox');
      await bookingBox.add({
        'name': _nameController.text,
        'people': _peopleController.text,
        'phone': _phoneController.text,
        'place': _placeController.text,
        'packageName': widget.package['packageName'] ?? widget.package['eventName'] ?? widget.package['concertName'] ?? 'Untitled',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking confirmed! We will connect with you soon.')),
      );

      _nameController.clear();
      _peopleController.clear();
      _phoneController.clear();
      _placeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.package['packageName'] ?? widget.package['eventName'] ?? widget.package['concertName'] ?? 'Package Details'),
        backgroundColor: const Color(0xff2596be),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.package['image'] != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(widget.package['image']!),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 100),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                widget.package['packageName'] ?? widget.package['eventName'] ?? widget.package['concertName'] ?? 'Untitled',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (widget.package['description'] != null && widget.package['description'].toString().isNotEmpty)
                Text(widget.package['description'], style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 20),
                  const SizedBox(width: 8),
                  Text(widget.package['company name'] ?? widget.package['place'] ?? 'Location not specified',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  Text(widget.package['date'] ?? 'Date not specified', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.attach_money, size: 20),
                  const SizedBox(width: 8),
                  Text('${widget.package['price'] ?? widget.package['pricePerHead'] ?? 'Price not specified'}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    TextFormField(
                      controller: _peopleController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Number of People'),
                      validator: (value) => value!.isEmpty ? 'Please enter number of people' : null,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                    ),
                    TextFormField(
                      controller: _placeController,
                      decoration: const InputDecoration(labelText: 'Place'),
                      validator: (value) => value!.isEmpty ? 'Please enter your place' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _confirmBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2596be),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: const Text('Confirm Booking'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

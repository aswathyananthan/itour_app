// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:image_picker/image_picker.dart';

// class PackagesPage extends StatefulWidget {
//   const PackagesPage({super.key});

//   @override
//   State<PackagesPage> createState() => _PackagesPageState();
// }

// class _PackagesPageState extends State<PackagesPage> {
//   late Box tourBox;
//   late Box eventBox;
//   late Box concertBox;
//   bool _boxesInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeHiveBoxes();
//   }

//   Future<void> _initializeHiveBoxes() async {
//     tourBox = await Hive.openBox('tourBox');
//     eventBox = await Hive.openBox('eventBox');
//     concertBox = await Hive.openBox('concertBox');
//     setState(() {
//       _boxesInitialized = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _boxesInitialized
//           ? SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildPackageList(tourBox, 'Tours'),
//                   _buildPackageList(eventBox, 'Events'),
//                   _buildPackageList(concertBox, 'Concerts'),
//                 ],
//               ),
//             )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }

//   Widget _buildPackageList(Box box, String title) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10),
//         box.isEmpty
//             ? const Text('No items available.')
//             : ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: box.length,
//                 itemBuilder: (context, index) {
//                   final package = box.getAt(index) as Map;
//                   return Card(
//                     child: ListTile(
//                       leading: package['image'] != null
//                           ? Image.file(
//                               File(package['image']!),
//                               width: 50,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, object, stackTrace) =>
//                                   const Icon(Icons.error),
//                             )
//                           : const Icon(Icons.image),
//                       title: Text(
//                         package['packageName'] ??
//                             package['eventName'] ??
//                             package['concertName'] ??
//                             '',
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(package['description'] ?? ''),
//                           const SizedBox(height: 4),
//                           Text(
//                               'Price: ${package['price'] ?? package['pricePerHead'] ?? 'N/A'}'),
//                           const SizedBox(height: 4),
//                           Text('Place: ${package['place'] ?? 'N/A'}'),
//                         ],
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit),
//                             onPressed: () {
//                               _showEditForm(context, box, index, package);
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () {
//                               _deletePackage(context, box, index);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   void _showEditForm(BuildContext context, Box box, int index, Map package) {
//     final _formKey = GlobalKey<FormState>();
//     final _nameController = TextEditingController(
//         text: package['packageName'] ??
//             package['eventName'] ??
//             package['concertName'] ??
//             '');
//     final _descriptionController =
//         TextEditingController(text: package['description'] ?? '');
//     final _priceController = TextEditingController(
//         text: package['price'] ?? package['pricePerHead'] ?? '');
//     final _placeController =
//         TextEditingController(text: package['place'] ?? '');
//     File? _image;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit Package'),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(labelText: 'Name'),
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(labelText: 'Description'),
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: _priceController,
//                     decoration: const InputDecoration(labelText: 'Price'),
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: _placeController,
//                     decoration: const InputDecoration(labelText: 'Place'),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final pickedFile = await ImagePicker()
//                           .pickImage(source: ImageSource.gallery);
//                       if (pickedFile != null) {
//                         setState(() {
//                           _image = File(pickedFile.path);
//                         });
//                       }
//                     },
//                     child: const Text('Select Image'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   final updatedPackage = {
//                     'packageName': _nameController.text,
//                     'eventName': _nameController.text,
//                     'concertName': _nameController.text,
//                     'description': _descriptionController.text,
//                     'price': _priceController.text,
//                     'pricePerHead': _priceController.text,
//                     'place': _placeController.text,
//                     'image': _image?.path ??
//                         package['image'], // Keep old image if not changed
//                   };
//                   box.putAt(index, updatedPackage);
//                   Navigator.pop(context);
//                   setState(() {}); // Refresh the list
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _deletePackage(BuildContext context, Box box, int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Confirm Delete'),
//           content: const Text('Are you sure you want to delete this package?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 box.deleteAt(index);
//                 Navigator.pop(context);
//                 setState(() {}); // Refresh the list
//               },
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _boxesInitialized
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPackageList(tourBox, 'Tours'),
                  _buildPackageList(eventBox, 'Events'),
                  _buildPackageList(concertBox, 'Concerts'),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPackageList(Box box, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        box.isEmpty
            ? const Text('No items available.')
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final package = box.getAt(index) as Map;
                  return Card(
                    child: ListTile(
                      leading: package['image'] != null
                          ? Image.file(
                              File(package['image']!),
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, object, stackTrace) =>
                                  const Icon(Icons.error),
                            )
                          : const Icon(Icons.image),
                      title: Text(
                        package['packageName'] ??
                            package['eventName'] ??
                            package['concertName'] ??
                            '',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(package['description'] ?? ''),
                          const SizedBox(height: 4),
                          Text(
                              'Price: ${package['price'] ?? package['pricePerHead'] ?? 'N/A'}'),
                          const SizedBox(height: 4),
                          Text('Place: ${package['place'] ?? 'N/A'}'),
                          const SizedBox(height: 4),
                          if (package['date'] != null)
                            Text('Date: ${_formatDate(package['date'])}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditForm(context, box, index, package);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deletePackage(context, box, index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        const SizedBox(height: 20),
      ],
    );
  }

  String _formatDate(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  void _showEditForm(BuildContext context, Box box, int index, Map package) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(
        text: package['packageName'] ??
            package['eventName'] ??
            package['concertName'] ??
            '');
    final _descriptionController =
        TextEditingController(text: package['description'] ?? '');
    final _priceController = TextEditingController(
        text: package['price'] ?? package['pricePerHead'] ?? '');
    final _placeController = TextEditingController(text: package['place'] ?? '');
    final _dateController = TextEditingController(text: package['date'] ?? '');
    File? _image;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Package'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _placeController,
                    decoration: const InputDecoration(labelText: 'Place'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      hintText: 'YYYY-MM-DD',
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(picked);
                      }
                    },
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _image = File(pickedFile.path);
                        });
                      }
                    },
                    child: const Text('Select Image'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedPackage = {
                    'packageName': _nameController.text,
                    'eventName': _nameController.text,
                    'concertName': _nameController.text,
                    'description': _descriptionController.text,
                    'price': _priceController.text,
                    'pricePerHead': _priceController.text,
                    'place': _placeController.text,
                    'date': _dateController.text,
                    'image': _image?.path ?? package['image'],
                  };
                  box.putAt(index, updatedPackage);
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deletePackage(BuildContext context, Box box, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this package?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                box.deleteAt(index);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}


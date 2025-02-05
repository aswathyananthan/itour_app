
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Adminhome extends StatefulWidget {
  const Adminhome({super.key});

  @override
  State<Adminhome> createState() => _AdminhomeState();
}

class _AdminhomeState extends State<Adminhome> {
  late Box tourBox;
  late Box eventBox;
  late Box concertBox;

  @override
  void initState() {
    super.initState();
    _initializeHiveBoxes();
  }

  Future<void> _initializeHiveBoxes() async {
    tourBox = await Hive.openBox('tourBox');
    eventBox = await Hive.openBox('eventBox');
    concertBox = await Hive.openBox('concertBox');
  }

  void _showTourForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _packageNameController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _companyNameController = TextEditingController();
    final _priceController = TextEditingController();
    final _placeController = TextEditingController();
    File? _image;
    DateTime? _selectedDate;

    Future<void> _pickImage(ImageSource source) async {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }

    Future<void> _pickDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }

    _showFormBottomSheet(
      context: context,
      formKey: _formKey,
      title: 'Add Tour Package',
      fields: [
        TextFormField(
          controller: _packageNameController,
          decoration: const InputDecoration(
            labelText: 'Package Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Please enter package name' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _companyNameController,
          decoration: const InputDecoration(
            labelText: 'Company Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Please enter company name' : null,
        ),
        const SizedBox(height: 10),
      TextFormField(                    // Add this field
        controller: _placeController,
        decoration: const InputDecoration(
          labelText: 'Place',
          border: OutlineInputBorder(),
        ),
        validator: (value) => value?.isEmpty ?? true ? 'Please enter place' : null,
      ),
      const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(
            labelText: 'Price',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter price';
            if (double.tryParse(value!) == null) return 'Please enter a valid number';
            return null;
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: _selectedDate != null
                    ? "${_selectedDate!.toLocal()}".split(' ')[0]
                    : '',
              ),
              validator: (value) => _selectedDate == null ? 'Please select a date' : null,
            ),
          ),
        ),
      ],
      onSave: () {
        if (_formKey.currentState!.validate()) {
          final tourData = {
            'packageName': _packageNameController.text,
            'companyName': _companyNameController.text,
            'description': _descriptionController.text,
            'place': _placeController.text,
            'price': _priceController.text,
            'date': _selectedDate?.toIso8601String(),
            'image': _image?.path,
          };
          tourBox.add(tourData); // Save to tourBox
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tour package added successfully!')),
          );
        }
      },
      image: _image,
      onPickImage: _pickImage,
    );
  }

  void _showEventForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _eventNameController = TextEditingController();
    final _placeController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _priceController = TextEditingController();
    File? _image;
    DateTime? _selectedDate;

    Future<void> _pickImage(ImageSource source) async {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }

    Future<void> _pickDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }

    _showFormBottomSheet(
      context: context,
      formKey: _formKey,
      title: 'Add Event',
      fields: [
        TextFormField(
          controller: _eventNameController,
          decoration: const InputDecoration(
            labelText: 'Event Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Please enter event name' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _placeController,
          decoration: const InputDecoration(
            labelText: 'Place',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Please enter place' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(
            labelText: 'Price Per Head',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter price';
            if (double.tryParse(value!) == null) return 'Please enter a valid number';
            return null;
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: _selectedDate != null
                    ? "${_selectedDate!.toLocal()}".split(' ')[0]
                    : '',
              ),
              validator: (value) => _selectedDate == null ? 'Please select a date' : null,
            ),
          ),
        ),
      ],
      onSave: () {
        if (_formKey.currentState!.validate()) {
          final eventData = {
            'eventName': _eventNameController.text,
            'place': _placeController.text,
            'description': _descriptionController.text,
            'pricePerHead': _priceController.text,
            'date': _selectedDate?.toIso8601String(),
            'image': _image?.path,
          };
          eventBox.add(eventData); // Save to eventBox
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event added successfully!')),
          );
        }
      },
      image: _image,
      onPickImage: _pickImage,
    );
  }

  void _showConcertForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _concertNameController = TextEditingController();
    final _placeController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _priceController = TextEditingController();
    File? _image;
    DateTime? _selectedDate;

    Future<void> _pickImage(ImageSource source) async {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }

    Future<void> _pickDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }

    _showFormBottomSheet(
      context: context,
      formKey: _formKey,
      title: 'Add Concert',
      fields: [
        TextFormField(
          controller: _concertNameController,
          decoration: const InputDecoration(
            labelText: 'Concert Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Please enter concert name' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _placeController,
          decoration: const InputDecoration(
            labelText: 'Place',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Please enter place' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _priceController,
          decoration: const InputDecoration(
            labelText: 'Price Per Head',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter price';
            if (double.tryParse(value!) == null) return 'Please enter a valid number';
            return null;
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: _selectedDate != null
                    ? "${_selectedDate!.toLocal()}".split(' ')[0]
                    : '',
              ),
              validator: (value) => _selectedDate == null ? 'Please select a date' : null,
            ),
          ),
        ),
      ],
      onSave: () {
        if (_formKey.currentState!.validate()) {
          final concertData = {
            'concertName': _concertNameController.text,
            'place': _placeController.text,
            'description': _descriptionController.text,
            'pricePerHead': _priceController.text,
            'date': _selectedDate?.toIso8601String(),
            'image': _image?.path,
          };
          concertBox.add(concertData); // Save to concertBox
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Concert added successfully!')),
          );
        }
      },
      image: _image,
      onPickImage: _pickImage,
    );
  }

  void _showFormBottomSheet({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String title,
    required List<Widget> fields,
    required VoidCallback onSave,
    required File? image,
    required Future<void> Function(ImageSource) onPickImage,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...fields,
                  const SizedBox(height: 10),
                  image == null
                      ? ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Gallery'),
                                      onTap: () {
                                        onPickImage(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Camera'),
                                      onTap: () {
                                        onPickImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: const Text('Upload Image'),
                        )
                      : Image.file(image),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: onSave,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _showTourForm(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.tour, size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Add Tour',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showEventForm(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.event, size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Add Event',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showConcertForm(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.greenAccent[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.music_note, size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Add Concert',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
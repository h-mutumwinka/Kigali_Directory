import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/place_model.dart';
import '../providers/place_provider.dart';

class EditPlaceScreen extends StatefulWidget {
  final Place place;
  const EditPlaceScreen({Key? key, required this.place}) : super(key: key);

  @override
  State<EditPlaceScreen> createState() => _EditPlaceScreenState();
}

class _EditPlaceScreenState extends State<EditPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, category, address, contact, description;
  late double latitude, longitude;
  bool isLoading = false;

  final List<String> categories = [
    "Hospital",
    "Police Station",
    "Library",
    "Restaurant",
    "Café",
    "Park",
    "Tourist Attraction",
    "Pharmacy",
    "School",
    "Bank",
    "Hotel"
  ];

  @override
  void initState() {
    super.initState();
    name = widget.place.name;
    category = widget.place.category;
    address = widget.place.address;
    contact = widget.place.contact;
    description = widget.place.description;
    latitude = widget.place.latitude;
    longitude = widget.place.longitude;
  }

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Place"),
        backgroundColor: const Color(0xFF0D1B2A), // Dark blue AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (val) => val!.isEmpty ? "Enter name" : null,
                  onSaved: (val) => name = val!,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  items: categories.map((String cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        category = newValue;
                      });
                    }
                  },
                  onSaved: (String? value) {
                    if (value != null) {
                      category = value;
                    }
                  },
                  validator: (val) => val == null ? "Select category" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: address,
                  decoration: const InputDecoration(labelText: "Address"),
                  validator: (val) => val!.isEmpty ? "Enter address" : null,
                  onSaved: (val) => address = val!,
                ),
                TextFormField(
                  initialValue: contact,
                  decoration: const InputDecoration(labelText: "Contact"),
                  validator: (val) => val!.isEmpty ? "Enter contact" : null,
                  onSaved: (val) => contact = val!,
                ),
                TextFormField(
                  initialValue: description,
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (val) => val!.isEmpty ? "Enter description" : null,
                  onSaved: (val) => description = val!,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() => isLoading = true);

                      final updatedPlace = Place(
                        id: widget.place.id,
                        name: name,
                        category: category,
                        address: address,
                        contact: contact,
                        description: description,
                        latitude: latitude,
                        longitude: longitude,
                        userId: widget.place.userId,
                        timestamp: DateTime.now(),
                      );

                      try {
                        await placeProvider.updatePlace(updatedPlace);
                        
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Place updated")),
                          );
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() => isLoading = false);
                        }
                      }
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
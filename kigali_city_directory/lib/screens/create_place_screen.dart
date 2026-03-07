import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/place_model.dart';
import '../providers/place_provider.dart';
import '../providers/auth_provider.dart' as auth;

class CreatePlaceScreen extends StatefulWidget {
  const CreatePlaceScreen({Key? key}) : super(key: key);

  @override
  State<CreatePlaceScreen> createState() => _CreatePlaceScreenState();
}

class _CreatePlaceScreenState extends State<CreatePlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = "", category = "Hospital", address = "", contact = "", description = "";
  double latitude = -1.9441, longitude = 30.0619; // Default to Kigali center
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
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Place"),
        backgroundColor: const Color(0xFF0D1B2A), // Dark blue AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Name
                TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                  validator: (val) => val!.isEmpty ? "Enter name" : null,
                  onSaved: (val) => name = val!,
                ),
                const SizedBox(height: 10),
                // Category Dropdown
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
                // Address
                TextFormField(
                  decoration: const InputDecoration(labelText: "Address"),
                  validator: (val) => val!.isEmpty ? "Enter address" : null,
                  onSaved: (val) => address = val!,
                ),
                // Contact
                TextFormField(
                  decoration: const InputDecoration(labelText: "Contact"),
                  validator: (val) => val!.isEmpty ? "Enter contact" : null,
                  onSaved: (val) => contact = val!,
                ),
                // Description
                TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (val) => val!.isEmpty ? "Enter description" : null,
                  onSaved: (val) => description = val!,
                ),
                // Latitude
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Latitude",
                    hintText: "e.g., -1.9441 (Kigali center)",
                  ),
                  initialValue: latitude.toString(),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Enter latitude";
                    if (double.tryParse(val) == null) return "Enter valid number";
                    return null;
                  },
                  onSaved: (val) => latitude = double.tryParse(val!) ?? -1.9441,
                ),
                // Longitude
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Longitude",
                    hintText: "e.g., 30.0619 (Kigali center)",
                  ),
                  initialValue: longitude.toString(),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Enter longitude";
                    if (double.tryParse(val) == null) return "Enter valid number";
                    return null;
                  },
                  onSaved: (val) => longitude = double.tryParse(val!) ?? 30.0619,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : () async {
                    print("Save button pressed");
                    if (_formKey.currentState!.validate()) {
                      print("Form validated successfully");
                      _formKey.currentState!.save();
                      print("Form saved - Name: $name, Category: $category");
                      setState(() => isLoading = true);

                      final newPlace = Place(
                        id: "", // Firestore will generate
                        name: name,
                        category: category,
                        address: address,
                        contact: contact,
                        description: description,
                        latitude: latitude,
                        longitude: longitude,
                        userId:
                            authProvider.user?.uid ?? "guest", // Current user
                        timestamp: DateTime.now(),
                      );

                      print("Attempting to save place: ${newPlace.name}");

                      try {
                        await placeProvider.addPlace(newPlace);
                        print("Place saved successfully");
                        
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Place created successfully"),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print("Error saving place: $e");
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
                    } else {
                      print("Form validation failed");
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

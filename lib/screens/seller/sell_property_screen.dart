// lib/screens/seller/sell_property_screen.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/providers.dart';
import '../../providers/property_submission_provider.dart';

class SellPropertyScreen extends ConsumerStatefulWidget {
  const SellPropertyScreen({super.key});

  @override
  ConsumerState<SellPropertyScreen> createState() =>
      _SellPropertyScreenState();
}

class _SellPropertyScreenState extends ConsumerState<SellPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  // CONTROLLERS
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final bedroomsController = TextEditingController();
  final bathroomsController = TextEditingController();
  final sizeController = TextEditingController();
  final yearBuiltController = TextEditingController();
  final sellerNameController = TextEditingController();
  final phoneController = TextEditingController();

  // LOCATION
  int? selectedRegionId;
  int? selectedDistrictId;
  int? selectedWardId;
  int? selectedCategoryId;
  int? selectedTypeId;

  String? selectedRegionName;
  String? selectedDistrictName;
  String? selectedWardName;
  String? selectedCategoryName;
  String? selectedTypeName;

  String country = "Tanzania";

  // PROPERTY
  String listingType = "Sale";

  final Set<int> selectedAmenityIds = {};
  final List<File> selectedImages = [];

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    bedroomsController.dispose();
    bathroomsController.dispose();
    sizeController.dispose();
    yearBuiltController.dispose();
    sellerNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final regionsAsync = ref.watch(regionsProvider);
    final amenitiesAsync = ref.watch(amenitiesProvider);
    final propertyTypesAsync = ref.watch(propertyTypesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final listingTypes = ref.watch(listingTypesProvider);
    
    // ✅ Watch submission state
    final submissionState = ref.watch(propertySubmissionProvider);

    final districtsAsync = selectedRegionId != null
        ? ref.watch(districtsProvider(selectedRegionId!))
        : null;

    final wardsAsync = selectedDistrictId != null
        ? ref.watch(wardsProvider(selectedDistrictId!))
        : null;

    // ✅ Listen to submission state changes
    ref.listen(propertySubmissionProvider, (previous, next) {
      if (next.isSuccess && next.data != null) {
        // Success - show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Property listed successfully!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        
        // ✅ Reset state and navigate back after snackbar is shown
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            final notifier = ref.read(propertySubmissionProvider.notifier);
            notifier.reset();
            Navigator.pop(context, true);
          }
        });
      } else if (next.error != null && !next.isLoading) {
        // Error - show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${next.error}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Sell Property",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  
                  // SECTION: Property Details
                  _buildSectionCard(
                    title: "Property Details",
                    icon: Iconsax.home,
                    children: [
                      _buildStyledInput(
                        controller: titleController,
                        icon: Iconsax.home,
                        label: "Property Title",
                        hint: "e.g. Modern Villa in Dar es Salaam",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter property title";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      _buildStyledInput(
                        controller: priceController,
                        icon: Iconsax.money,
                        label: "Price (TZS)",
                        hint: "e.g. 150,000,000",
                        type: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter price";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      _buildStyledInput(
                        controller: descriptionController,
                        icon: Iconsax.document_text,
                        label: "Description",
                        hint: "Describe your property in detail...",
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter description";
                          }
                          if (value.length < 20) {
                            return "Description must be at least 20 characters";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION: Property Type & Category
                  _buildSectionCard(
                    title: "Property Type & Category",
                    icon: Iconsax.tag,
                    children: [
                      _buildDropdownField(
                        label: "Property Type",
                        hint: "Select property type",
                        value: selectedTypeName,
                        items: propertyTypesAsync,
                        onChanged: (value, id) {
                          setState(() {
                            selectedTypeName = value;
                            selectedTypeId = id;
                          });
                        },
                        provider: propertyTypesProvider,
                      ),
                      const SizedBox(height: 14),
                      _buildDropdownField(
                        label: "Category",
                        hint: "Select category",
                        value: selectedCategoryName,
                        items: categoriesAsync,
                        onChanged: (value, id) {
                          setState(() {
                            selectedCategoryName = value;
                            selectedCategoryId = id;
                          });
                        },
                        provider: categoriesProvider,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION: Location
                  _buildSectionCard(
                    title: "Location",
                    icon: Iconsax.location,
                    children: [
                      _buildLocationField(
                        icon: Icons.public,
                        label: "Country",
                        value: "Tanzania",
                      ),
                      const SizedBox(height: 14),
                      _buildDropdownField(
                        label: "Region",
                        hint: "Select region",
                        value: selectedRegionName,
                        items: regionsAsync,
                        onChanged: (value, id) {
                          setState(() {
                            selectedRegionName = value;
                            selectedRegionId = id;
                            selectedDistrictId = null;
                            selectedDistrictName = null;
                            selectedWardId = null;
                            selectedWardName = null;
                          });
                        },
                        provider: regionsProvider,
                      ),
                      const SizedBox(height: 14),
                      if (selectedRegionId != null && districtsAsync != null)
                        _buildDropdownField(
                          label: "District",
                          hint: "Select district",
                          value: selectedDistrictName,
                          items: districtsAsync,
                          onChanged: (value, id) {
                            setState(() {
                              selectedDistrictName = value;
                              selectedDistrictId = id;
                              selectedWardId = null;
                              selectedWardName = null;
                            });
                          },
                          provider: districtsProvider(selectedRegionId!),
                        ),
                      if (selectedDistrictId != null && wardsAsync != null) ...[
                        const SizedBox(height: 14),
                        _buildDropdownField(
                          label: "Ward",
                          hint: "Select ward",
                          value: selectedWardName,
                          items: wardsAsync,
                          onChanged: (value, id) {
                            setState(() {
                              selectedWardName = value;
                              selectedWardId = id;
                            });
                          },
                          provider: wardsProvider(selectedDistrictId!),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION: Listing Type
                  _buildSectionCard(
                    title: "Listing Type",
                    icon: Iconsax.tag,
                    children: [
                      _buildRadioGroup(
                        value: listingType,
                        options: listingTypes,
                        onChanged: (value) {
                          setState(() => listingType = value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION: Property Features
                  _buildSectionCard(
                    title: "Property Features",
                    icon: Iconsax.building,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStyledInput(
                              controller: bedroomsController,
                              icon: Icons.bed,
                              label: "Bedrooms",
                              hint: "e.g. 3",
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStyledInput(
                              controller: bathroomsController,
                              icon: Icons.bathroom,
                              label: "Bathrooms",
                              hint: "e.g. 2",
                              type: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildStyledInput(
                        controller: sizeController,
                        icon: Icons.square_foot,
                        label: "Size (sqm)",
                        hint: "e.g. 250",
                        type: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      _buildStyledInput(
                        controller: yearBuiltController,
                        icon: Icons.calendar_today,
                        label: "Year Built",
                        hint: "e.g. 2020",
                        type: TextInputType.number,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION: Amenities
                  _buildSectionCard(
                    title: "Amenities",
                    icon: Iconsax.star,
                    children: [
                      amenitiesAsync.when(
                        data: (amenities) {
                          if (amenities.isEmpty) {
                            return const Text(
                              "No amenities available",
                              style: TextStyle(color: Colors.grey),
                            );
                          }
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: amenities.map<Widget>((item) {
                              final id = item['id'];
                              final name = item['name'] ?? '';
                              final selected = selectedAmenityIds.contains(id);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected
                                        ? selectedAmenityIds.remove(id)
                                        : selectedAmenityIds.add(id);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFF22C55E)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected
                                          ? const Color(0xFF22C55E)
                                          : Colors.grey[300]!,
                                      width: 1.5,
                                    ),
                                    boxShadow: selected
                                        ? [
                                            BoxShadow(
                                              color: Colors.green.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (selected)
                                        const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      if (selected) const SizedBox(width: 4),
                                      Text(
                                        name,
                                        style: TextStyle(
                                          color: selected ? Colors.white : Colors.black87,
                                          fontWeight: selected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => _loadingIndicator(),
                        error: (error, _) => _errorWidget(
                          "Amenities",
                          error.toString(),
                          onRetry: () => ref.refresh(amenitiesProvider),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION: Images
                  _buildSectionCard(
                    title: "Property Images",
                    icon: Iconsax.image,
                    children: [
                      _buildImagePicker(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION: Contact Details
                  _buildSectionCard(
                    title: "Contact Details",
                    icon: Iconsax.call,
                    children: [
                      _buildStyledInput(
                        controller: sellerNameController,
                        icon: Icons.person,
                        label: "Full Name",
                        hint: "e.g. John Doe",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      _buildStyledInput(
                        controller: phoneController,
                        icon: Icons.phone,
                        label: "Phone Number",
                        hint: "e.g. 0712345678",
                        type: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter phone number";
                          }
                          if (value.length < 10) {
                            return "Enter a valid phone number";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // SUBMIT BUTTON
                  _buildSubmitButton(submissionState.isLoading),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // ✅ Show loading overlay when submitting
          if (submissionState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Submitting property...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // =========================
  // IMAGE PICKER
  // =========================
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(selectedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImages.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildImageButton(
                icon: Icons.photo_library,
                label: "Gallery",
                color: Colors.blue,
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildImageButton(
                icon: Icons.camera_alt,
                label: "Camera",
                color: Colors.green,
                onPressed: () => _pickImage(ImageSource.camera),
              ),
            ),
          ],
        ),
        if (selectedImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '${selectedImages.length} images selected',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // =========================
  // SUBMIT PROPERTY - WITH RIVERPOD
  // =========================
  void _submitProperty() {
    if (!_formKey.currentState!.validate()) return;

    // ✅ Use default userId = 1
    const userId = 1;

    // ✅ Convert amenityIds list to JSON string
    final amenityIdsString = jsonEncode(selectedAmenityIds.toList());

    // Build the property data
    final propertyData = {
      'title': titleController.text.trim(),
      'price': double.tryParse(priceController.text) ?? 0,
      'description': descriptionController.text.trim(),
      'typeId': selectedTypeId,
      'userId': userId,
      'wardId': selectedWardId,
      'categoryId': selectedCategoryId,
      'amenityIds': amenityIdsString,
      'bedrooms': int.tryParse(bedroomsController.text) ?? 0,
      'bathrooms': int.tryParse(bathroomsController.text) ?? 0,
      'size': double.tryParse(sizeController.text) ?? 0,
      'yearBuilt': int.tryParse(yearBuiltController.text) ?? 0,
      'sellerName': sellerNameController.text.trim(),
      'phone': phoneController.text.trim(),
    };

    print('📤 Submitting property data: $propertyData');
    print('📤 Images: ${selectedImages.length}');

    // ✅ Trigger submission using Riverpod
    final notifier = ref.read(propertySubmissionProvider.notifier);
    notifier.submitProperty(
      data: propertyData,
      images: selectedImages,
    );
  }

  // =========================
  // BUILD HELPER WIDGETS
  // =========================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🏠 List Your Property",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Reach thousands of buyers & renters instantly",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF22C55E), size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledInput({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF22C55E), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required AsyncValue<List<dynamic>> items,
    required Function(String name, int id) onChanged,
    required dynamic provider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        items.when(
          data: (data) {
            if (data.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  "No $label available",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    hint,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                underline: const SizedBox(),
                icon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ),
                items: data.map<DropdownMenuItem<String>>((item) {
                  final name = item['name'] ?? '';
                  final id = item['id'];
                  return DropdownMenuItem(
                    value: name,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(name),
                    ),
                    onTap: () => onChanged(name, id),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            );
          },
          loading: () => _loadingIndicator(),
          error: (error, _) => _errorWidget(
            label,
            error.toString(),
            onRetry: () => ref.refresh(provider),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[500], size: 20),
              const SizedBox(width: 12),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioGroup({
    required String value,
    required List<String> options,
    required Function(String) onChanged,
  }) {
    return Row(
      children: options.map((option) {
        final isSelected = value == option;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF22C55E) : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF22C55E)
                      : Colors.grey[200]!,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  option == "Sale" ? "For Sale" : "For Rent",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: isLoading ? null : _submitProperty,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 22),
                  SizedBox(width: 10),
                  Text(
                    "Publish Property",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF22C55E),
          ),
        ),
      ),
    );
  }

  Widget _errorWidget(String label, String error, {VoidCallback? onRetry}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Failed to load $label",
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[700],
              ),
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
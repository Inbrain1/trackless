import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:untitled2/features/3_shell_navigation/data/datasources/discovery_service.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/discovery_card_model_new.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/transport_option_model.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled2/features/3_shell_navigation/presentation/screens/location_picker_screen.dart';

class CreateCardScreen extends StatefulWidget {
  const CreateCardScreen({super.key});

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _tagController = TextEditingController();

  // Premium / Extra controllers
  final _priceController = TextEditingController(text: '0');
  final _originalPriceController = TextEditingController();
  final _ratingController = TextEditingController(text: '4.5');
  final _descriptionController = TextEditingController();
  final _yearController = TextEditingController(text: '2025');
  bool _isVerified = true;

  // Location fields
  double? _latitude;
  double? _longitude;
  List<TransportOption> _transportOptions = [];

  String _selectedType = 'steam_style';
  bool _isLoading = false;

  final DiscoveryService _discoveryService = DiscoveryService(firestore: sl());

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_imageUrlController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add a main image')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final card = DiscoveryCardModel(
          title: _titleController.text,
          subtitle: _subtitleController.text,
          imageUrl: _imageUrlController.text,
          tag: _tagController.text.isEmpty ? 'New' : _tagController.text,
          type: _selectedType,
          createdAt: DateTime.now(),
          price: double.tryParse(_priceController.text) ?? 0.0,
          originalPrice: _originalPriceController.text.isNotEmpty
              ? double.tryParse(_originalPriceController.text)
              : null,
          rating: double.tryParse(_ratingController.text) ?? 0.0,
          description: _descriptionController.text,
          year: _yearController.text,
          isVerified: _isVerified,
          latitude: _latitude,
          longitude: _longitude,
          busIds: [], // Deprecated field, keeping empty for backward compatibility
          transportOptions: _transportOptions,
        );

        await _discoveryService.addDiscoveryCard(card);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card created successfully!')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark background
      appBar: AppBar(
        title: const Text('New Card', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // --- MAIN IMAGE UPLOAD ---
              _buildUploadBox(
                label: 'Upload Main Image',
                controller: _imageUrlController,
                height: 200,
              ),
              const SizedBox(height: 16),

              // --- TITLE ---
              _buildDarkTextField(
                controller: _titleController,
                label: 'Title',
                isTitle: true,
              ),
              const SizedBox(height: 16),

              // --- ROW: AÑO & STAR ---
              Row(
                children: [
                  Expanded(
                    child: _buildBorderedField(
                      controller: _yearController,
                      label: 'año',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBorderedField(
                      controller: _ratingController,
                      label: 'star',
                      icon: Icons.star,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- LOCATION PICKER ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LocationPickerScreen()),
                    );

                    // Result is a List containing [LatLng location, List<TransportOption> options]
                    if (result != null &&
                        result is List &&
                        result.length == 2) {
                      final location = result[0] as google_maps.LatLng;
                      final transportOptions =
                          result[1] as List<TransportOption>;

                      setState(() {
                        _latitude = location.latitude;
                        _longitude = location.longitude;
                        _transportOptions = transportOptions;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '✓ ${transportOptions.length} rutas curadas')),
                      );
                    }
                  },
                  icon: Icon(_latitude != null ? Icons.check : Icons.map,
                      color: Colors.white),
                  label: Text(
                    _latitude != null
                        ? '✓ Ubicación y ${_transportOptions.length} Rutas Curadas'
                        : 'Definir Ubicación (Cómo llegar)',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _latitude != null ? Colors.green : Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- TAG ---
              Row(
                children: [
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                    ),
                    child: IntrinsicWidth(
                      child: TextField(
                        controller: _tagController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Tag +',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- SECTION: COMO ES EL LUGAR ---
              const Text(
                'como es el luagr', // Preserving user's typo phrasing or keeping it simple
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // --- GALLERY UPLOAD (Secondary) ---
              // For now simpler logic: just another way to verify image uploads logic,
              // maybe we can skip actual functional gallery list and just show the box as visual
              _buildUploadBox(
                label: 'Upload Gallery Image',
                controller: TextEditingController(), // Dummy for visual
                height: 150,
                isSecondary: true,
              ),
              const SizedBox(height: 16),

              // --- SUBTITLES ---
              _buildDarkTextField(
                controller: _subtitleController,
                label: 'Subtitletes',
              ),
              const SizedBox(height: 8),

              // --- DESCRIPTION (dots.....) ---
              _buildDarkTextField(
                controller: _descriptionController,
                label: '.......',
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // --- EXPANDABLE ADVANCED OPTIONS (Price, Type, etc) ---
              ExpansionTile(
                title: const Text('Advanced Options',
                    style: TextStyle(color: Colors.white70)),
                iconColor: Colors.white70,
                collapsedIconColor: Colors.white70,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: _buildDarkTextField(
                                    controller: _priceController,
                                    label: 'Price')),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _buildDarkTextField(
                                    controller: _originalPriceController,
                                    label: 'Orig. Price')),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SwitchListTile(
                          title: const Text('Verified',
                              style: TextStyle(color: Colors.white)),
                          value: _isVerified,
                          activeColor: Colors.white,
                          onChanged: (val) => setState(() => _isVerified = val),
                        ),
                        DropdownButtonFormField<String>(
                          dropdownColor: const Color(0xFF1A1A1A),
                          value: _selectedType,
                          style: const TextStyle(color: Colors.white),
                          items: const [
                            DropdownMenuItem(
                                value: 'steam_style',
                                child: Text('Steam Style')),
                            DropdownMenuItem(
                                value: 'popular', child: Text('Popular')),
                            DropdownMenuItem(
                                value: 'carousel',
                                child: Text('Carousel Highlight')),
                          ],
                          onChanged: (v) => setState(() => _selectedType = v!),
                          decoration: const InputDecoration(
                            labelText: 'Type',
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white54)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),

              // --- SAVE BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(_isLoading ? 'Saving...' : 'CREATE CARD'),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox({
    required String label,
    required TextEditingController controller,
    double height = 150,
    bool isSecondary = false,
  }) {
    return GestureDetector(
      onTap: () {
        _showUrlDialog(controller);
      },
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white),
          // If image is set, show it
          image: controller.text.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(controller.text), fit: BoxFit.cover)
              : null,
        ),
        child: controller.text.isNotEmpty
            ? null // Show nothing if image is there
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Using the asset provided by user request
                  Image.asset(
                    'assets/uplogad.png',
                    width: 50,
                    height: 50,
                    color: Colors.white,
                    errorBuilder: (c, e, s) =>
                        const Icon(Icons.upload, color: Colors.white, size: 50),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDarkTextField({
    required TextEditingController controller,
    required String label,
    bool isTitle = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty && !label.startsWith('.'))
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white)),
          ),
          child: TextFormField(
            controller: controller,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTitle ? 22 : 16,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: label.startsWith('.') ? label : null,
              hintStyle: const TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBorderedField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
  }) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.yellow, size: 16),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Future<void> _showUrlDialog(TextEditingController controller) async {
    final urlController = TextEditingController(text: controller.text);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Enter Image URL',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: urlController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'https://...',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                controller.text = urlController.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Set Image'),
          ),
        ],
      ),
    );
  }
}

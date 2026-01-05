import 'package:flutter/material.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/3_shell_navigation/data/datasources/discovery_service.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/discovery_card_model_new.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/transport_option_model.dart';
import 'package:untitled2/features/3_shell_navigation/presentation/screens/location_picker_screen.dart';

class CreateCardScreen extends StatefulWidget {
  final DiscoveryCardModel? cardToEdit;

  const CreateCardScreen({super.key, this.cardToEdit});

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Services
  final DiscoveryService _discoveryService = DiscoveryService(firestore: sl());

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _descriptionController;
  late TextEditingController _ratingController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _imageUrlController; // NEW: URL input instead of file picker

  // State - Type and Tag selectors
  String? _selectedType;
  String? _selectedTag;
  
  List<TransportOption> _transportOptions = [];
  bool _isVerified = false;
  bool _isUploading = false;

  // Type options
  final List<String> _typeOptions = ['Carousel', 'Supermarket', 'Tourism', 'Market', 'Plaza'];
  
  // Tag options
  final List<String> _tagOptions = ['Aventura', 'Familia', 'Compras', 'Cultural', 'Gastronomía'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.cardToEdit != null) {
      _populateForm(widget.cardToEdit!);
    }
  }

  void _initializeControllers() {
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    _descriptionController = TextEditingController();
    _ratingController = TextEditingController(text: '4.5');
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _imageUrlController = TextEditingController(); // NEW
  }

  void _populateForm(DiscoveryCardModel card) {
    _titleController.text = card.title;
    _subtitleController.text = card.subtitle;
    _descriptionController.text = card.description;
    _ratingController.text = card.rating.toString();
    _imageUrlController.text = card.imageUrl; // NEW: Populate URL
    
    _selectedType = card.type;
    _selectedTag = card.tag;
    
    _transportOptions = List.from(card.transportOptions);
    _isVerified = card.isVerified;
    
    if (card.latitude != null) {
      _latitudeController.text = card.latitude.toString();
    }
    if (card.longitude != null) {
      _longitudeController.text = card.longitude.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imageUrlController.dispose(); // NEW
    super.dispose();
  }

  // --- Actions ---

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
    );

    if (result != null) {
       if (result is List) {
          final latLng = result[0];
          final List<TransportOption> options = result[1];

          setState(() {
            _latitudeController.text = latLng.latitude.toString();
            _longitudeController.text = latLng.longitude.toString();
            _transportOptions = options;
          });
       }
    }
  }
  
  void _removeTransportOption(int index) {
    setState(() {
      _transportOptions.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Validate type and tag
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a type')),
      );
      return;
    }
    
    if (_selectedTag == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a tag')),
      );
      return;
    }
    
    // Validate image URL
    if (_imageUrlController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an image URL')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Prepare Model - use URL directly
      final newCard = DiscoveryCardModel(
        title: _titleController.text,
        subtitle: _subtitleController.text,
        imageUrl: _imageUrlController.text, // Use URL from text field
        tag: _selectedTag!,
        type: _selectedType!,
        description: _descriptionController.text,
        price: 0.0,
        rating: double.tryParse(_ratingController.text) ?? 0.0,
        createdAt: widget.cardToEdit?.createdAt ?? DateTime.now(),
        isVerified: _isVerified,
        isVideo: false, // Always false since we're using URLs
        latitude: double.tryParse(_latitudeController.text),
        longitude: double.tryParse(_longitudeController.text),
        transportOptions: _transportOptions,
        id: widget.cardToEdit?.id,
      );
      
      print('DEBUG: Saving Bus IDs: ${_transportOptions.map((e) => e.busId).toList()}');

      // Save (Create or Update)
      // Only update if we have a valid ID. Duplicated cards have cardToEdit set but id is null.
      if (widget.cardToEdit?.id != null) {
        await _discoveryService.updateDiscoveryCard(newCard);
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card updated successfully!')),
          );
          Navigator.pop(context);
        }
      } else {
        await _discoveryService.addDiscoveryCard(newCard); // Creates new with auto-ID
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card created successfully!')),
          );
          Navigator.pop(context);
        }
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving card: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  // --- UI Builders ---

  @override
  Widget build(BuildContext context) {
    // Editing means cardToEdit exists AND has an ID
    final isEditing = widget.cardToEdit?.id != null;
    // Duplicating means cardToEdit exists but NO ID
    final isDuplicating = widget.cardToEdit != null && widget.cardToEdit!.id == null;
    
    String title = 'Crear Nueva Tarjeta';
    if (isEditing) title = 'Editar Tarjeta';
    if (isDuplicating) title = 'Duplicar Tarjeta';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, 
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle('Image URL'),
                  const SizedBox(height: 12),
                  _buildImageUrlInput(),
                  
                  const SizedBox(height: 24),
                  
                  _buildSectionTitle('Basic Information'),
                  _buildTextField(_titleController, 'Title', Icons.title),
                  _buildTextField(_subtitleController, 'Subtitle', Icons.subtitles),
                  _buildTextField(_descriptionController, 'Description', Icons.description, maxLines: 3),
                  
                  const SizedBox(height: 24),
                  
                  _buildSectionTitle('Type & Category'),
                  const SizedBox(height: 12),
                  
                  // Type Dropdown
                  _buildTypeDropdown(),
                  const SizedBox(height: 16),
                  
                  // Tag Chips
                  const Text('Tag', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildTagChips(),
                  
                  const SizedBox(height: 24),
                  
                  _buildSectionTitle('Details'),
                  _buildTextField(_ratingController, 'Rating (0-5)', Icons.star, isNumber: true),
                  CheckboxListTile(
                    title: const Text('Verified Location', style: TextStyle(color: Colors.white)),
                    value: _isVerified, 
                    onChanged: (val) => setState(() => _isVerified = val ?? false),
                    activeColor: Colors.amber,
                    contentPadding: EdgeInsets.zero,
                  ),

                  const SizedBox(height: 24),
                  
                  _buildSectionTitle('Location & Transport'),
                  const SizedBox(height: 8),
                  
                  // Location Preview
                  if (_latitudeController.text.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.greenAccent),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lat: ${_latitudeController.text}', style: const TextStyle(color: Colors.white70)),
                              Text('Lng: ${_longitudeController.text}', style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  
                  OutlinedButton.icon(
                    onPressed: _pickLocation,
                    icon: const Icon(Icons.map, color: Colors.amber),
                    label: const Text('Pick Location & Transport', style: TextStyle(color: Colors.amber)),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.amber)),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  if (_transportOptions.isNotEmpty) ...[
                    const Text('Attached Transport Options:', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _transportOptions.length,
                      itemBuilder: (context, index) {
                        final option = _transportOptions[index];
                        return Card(
                          color: Colors.grey[900],
                          child: ListTile(
                            leading: const Icon(Icons.directions_bus, color: Colors.white),
                            title: Text(option.busName, style: const TextStyle(color: Colors.white)),
                            subtitle: Text('${option.recommendedStops.length} stops selected', style: const TextStyle(color: Colors.grey)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _removeTransportOption(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 40),
                  
                  ElevatedButton(
                    onPressed: _isUploading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _isUploading 
                          ? 'SAVING...' 
                          : (isEditing ? 'UPDATE CARD' : (isDuplicating ? 'CREATE DUPLICATE' : 'CREATE CARD')),
                      style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          if (_isUploading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: Colors.amber)),
            ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold));
  }

  // NEW: Image URL Input with Preview
  Widget _buildImageUrlInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // URL Text Field
        TextFormField(
          controller: _imageUrlController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Image URL',
            hintText: 'https://example.com/image.jpg',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            prefixIcon: const Icon(Icons.link, color: Colors.white70),
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Image URL is required';
            if (!value.startsWith('http://') && !value.startsWith('https://')) {
              return 'URL must start with http:// or https://';
            }
            return null;
          },
          onChanged: (value) {
            // Trigger rebuild to show preview
            setState(() {});
          },
        ),
        
        const SizedBox(height: 16),
        
        // Image Preview
        if (_imageUrlController.text.isNotEmpty)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _imageUrlController.text,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, size: 50, color: Colors.white54),
                          SizedBox(height: 8),
                          Text('Invalid URL or image failed to load', 
                            style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.amber,
                    ),
                  );
                },
              ),
            ),
          )
        else
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, style: BorderStyle.solid),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 50, color: Colors.white54),
                  SizedBox(height: 8),
                  Text('Enter a URL to preview image', 
                    style: TextStyle(color: Colors.white54)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      decoration: InputDecoration(
        labelText: 'Type',
        prefixIcon: const Icon(Icons.category, color: Colors.white70),
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      dropdownColor: Colors.grey[900],
      style: const TextStyle(color: Colors.white),
      items: _typeOptions.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedType = newValue;
        });
      },
      validator: (value) => value == null ? 'Type is required' : null,
    );
  }

  Widget _buildTagChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _tagOptions.map((String tag) {
        final isSelected = _selectedTag == tag;
        return ChoiceChip(
          label: Text(tag),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              _selectedTag = selected ? tag : null;
            });
          },
          selectedColor: Colors.amber,
          backgroundColor: Colors.grey[800],
          labelStyle: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        validator: (value) => value == null || value.isEmpty ? '$label is required' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white70),
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

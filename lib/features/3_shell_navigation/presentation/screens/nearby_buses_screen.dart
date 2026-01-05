import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/core/di/service_locator.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/selected_bus_data.dart';
import 'package:untitled2/features/3_shell_navigation/presentation/screens/bus_route_selector_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Screen to display and select nearby buses for transport curation
/// Part of Phase 1: Multi-Selection Bus List
class NearbyBusesScreen extends StatefulWidget {
  final LatLng location;

  const NearbyBusesScreen({super.key, required this.location});

  @override
  State<NearbyBusesScreen> createState() => _NearbyBusesScreenState();
}

class _NearbyBusesScreenState extends State<NearbyBusesScreen> {
  final FirebaseFirestore _firestore = sl<FirebaseFirestore>();
  final Map<String, SelectedBusData> _selectedBuses = {};
  
  List<DocumentSnapshot> _buses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchBuses();
  }

  Future<void> _fetchBuses() async {
    try {
      final snapshot = await _firestore.collection('buses').orderBy('mainName').get();
      if (mounted) {
        setState(() {
          _buses = snapshot.docs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar buses: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _toggleBusSelection(String busId, String busName) {
    setState(() {
      if (_selectedBuses.containsKey(busId)) {
        _selectedBuses.remove(busId);
      } else {
        _selectedBuses[busId] = SelectedBusData(busId: busId, busName: busName);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedBuses.length == _buses.length) {
        // Deselect all
        _selectedBuses.clear();
      } else {
        // Select all
        for (var doc in _buses) {
          final data = doc.data() as Map<String, dynamic>;
          final busId = doc.id;
          final busName = data['mainName'] ?? 'Desconocido';
          _selectedBuses[busId] = SelectedBusData(busId: busId, busName: busName);
        }
      }
    });
  }

  void _proceedToWizard() {
    if (_selectedBuses.isEmpty) return;

    Navigator.of(context)
        .push<List<dynamic>>(
      MaterialPageRoute(
        builder: (context) => BusRouteSelectorScreen(
          selectedBuses: _selectedBuses.values.toList(),
          targetLocation: widget.location,
        ),
      ),
    )
        .then((result) {
      // If wizard completed, pass result back
      if (result != null && mounted) {
        Navigator.of(context).pop(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allSelected = _buses.isNotEmpty && _selectedBuses.length == _buses.length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          'Selecciona Buses',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _toggleSelectAll,
            child: Text(
              allSelected ? 'Deseleccionar' : 'Seleccionar Todo',
              style: TextStyle(
                color: _isLoading ? Colors.white30 : Colors.amber, 
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _selectedBuses.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _proceedToWizard,
              backgroundColor: const Color(0xFF007BFF),
              icon: const Icon(Icons.route, color: Colors.white),
              label: Text(
                'Configurar Paradas (${_selectedBuses.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red.shade300),
        ),
      );
    }

    if (_buses.isEmpty) {
      return const Center(
        child: Text(
          'No hay buses disponibles',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _buses.length,
      itemBuilder: (context, index) {
        final doc = _buses[index];
        final data = doc.data() as Map<String, dynamic>;
        final busId = doc.id;
        final busName = data['mainName'] ?? 'Desconocido';
        final stops = data['stops'] as List<dynamic>?;
        final stopCount = stops?.length ?? 0;

        final isSelected = _selectedBuses.containsKey(busId);

        return _buildBusCard(
          busId: busId,
          busName: busName,
          stopCount: stopCount,
          isSelected: isSelected,
        );
      },
    );
  }

  Widget _buildBusCard({
    required String busId,
    required String busName,
    required int stopCount,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF007BFF).withValues(alpha: 0.15)
            : const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF007BFF) : Colors.transparent,
          width: 2,
        ),
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (value) => _toggleBusSelection(busId, busName),
        activeColor: const Color(0xFF007BFF),
        checkColor: Colors.white,
        title: Text(
          busName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white54, size: 16),
              const SizedBox(width: 4),
              Text(
                '$stopCount paradas',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

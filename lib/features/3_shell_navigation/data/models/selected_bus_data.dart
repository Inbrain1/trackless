/// Temporary data class for passing selected buses between screens
/// Used in the wizard flow to track which buses have been selected
class SelectedBusData {
  final String busId;
  final String busName;

  SelectedBusData({
    required this.busId,
    required this.busName,
  });
}

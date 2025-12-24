import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/features/3_shell_navigation/data/models/discovery_card_model_new.dart';

class DiscoveryService {
  final FirebaseFirestore _firestore;

  DiscoveryService({required FirebaseFirestore firestore}) : _firestore = firestore;

  Stream<List<DiscoveryCardModel>> getDiscoveryCards() {
    return _firestore
        .collection('discovery_cards')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => DiscoveryCardModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> addDiscoveryCard(DiscoveryCardModel card) async {
    await _firestore.collection('discovery_cards').add(card.toFirestore());
  }

  Future<void> deleteDiscoveryCard(String id) async {
    await _firestore.collection('discovery_cards').doc(id).delete();
  }
}

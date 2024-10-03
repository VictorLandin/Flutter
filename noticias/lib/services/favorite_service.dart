import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesService {
  final CollectionReference favoritesCollection =
    FirebaseFirestore.instance.collection('favorites');

  // Add favorite news article
  Future<DocumentReference<Map<String, dynamic>>> addFavorite(String userId, Map<String, dynamic> articleData) async {
    return await favoritesCollection
      .doc(userId)
      .collection('news')
      .add(articleData);
  }

  // Add favorite publisher
  Future<DocumentReference<Map<String, dynamic>>> addFavoritePublisher(String userId, String publisherName) async {
    return await favoritesCollection
      .doc(userId)
      .collection('publishers')
      .add({'name': publisherName});
  }

  // Get user's favorite news
  Stream<List<DocumentSnapshot>> getUserFavorites(String userId) {
    return favoritesCollection
      .doc(userId)
      .collection('news')
      .snapshots()
      .map((snapshot) => snapshot.docs);
  }
}

import 'package:firebase_database/firebase_database.dart';

class FavoritesService {
  final DatabaseReference favoritesRef = FirebaseDatabase.instance.ref('favorites');

  // Add favorite news article
  Future<void> addFavorite(String userId, Map<String, dynamic> articleData) async {
    await FirebaseDatabase.instance.ref('users/$userId/favorites').push().set(articleData);
  }

  // Add favorite publisher
  Future<void> addFavoritePublisher(String userId, String publisherName) async {
    await FirebaseDatabase.instance
        .ref('users/$userId/favoritePublishers')
        .push()
        .set({'name': publisherName});
  }

  // Get user's favorite news
  Stream<List<Map<String, dynamic>>> getUserFavorites(String userId) {
    final userFavoritesRef = FirebaseDatabase.instance.ref('users/$userId/favorites');
    return userFavoritesRef.onValue.map((event) {
      if (event.snapshot.value == null) return [];
      final Map<dynamic, dynamic> favoritesMap = event.snapshot.value as Map;
      return favoritesMap.values.cast<Map<String, dynamic>>().toList();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:noticias/models/news_models.dart';
import 'package:noticias/widgets/lista_noticias.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_database/firebase_database.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localization.favorites)),
      body: FutureBuilder<DataSnapshot>(
        future: FirebaseDatabase.instance.ref('users/$userId/favorites').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.value == null) {
            return Center(child: Text(localization.noFavorites));
          }

          // Convertir los datos obtenidos en una lista de artículos
          final List<Article> favorites = (snapshot.data!.value as Map).values.map<Article>((item) {
            return Article(
              source: Source(
                id: item['sourceId'],
                name: item['source'] ?? 'Desconocido',
              ),
              author: item['author'],
              title: item['title'] ?? 'Sin título',
              description: item['description'],
              url: item['url'] ?? '',
              urlToImage: item['urlToImage'],
              publishedAt: DateTime.tryParse(item['publishedAt'] ?? '') ?? DateTime.now(),
              content: item['content'],
            );
          }).toList();

          return ListaNoticias(favorites);
        },
      ),
    );
  }
}

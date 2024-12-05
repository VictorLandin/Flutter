import 'package:flutter/material.dart';
import 'package:noticias/models/news_models.dart';
import 'package:noticias/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Importar url_launcher
import 'package:firebase_auth/firebase_auth.dart';
import '../services/notifications_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/theme_provider.dart'; // Importar Firestore

class ListaNoticias extends StatelessWidget {
  const ListaNoticias(this.noticias, {super.key});

  final List<Article> noticias;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: noticias.length,
      itemBuilder: (BuildContext context, int index) {
        return _Noticia(noticia: noticias[index], index: index);
      },
    );
  }
}

class _Noticia extends StatelessWidget {
  const _Noticia({required this.noticia, required this.index});

  final Article noticia;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _abrirNoticia(context, noticia.url),
      child: Column(
        children: [
          _TarjetaTopBar(noticia: noticia, index: index),
          _TarjetaTitulo(noticia: noticia),
          if (noticia.urlToImage != null)
            _TarjetaImagen(noticia: noticia),
          _TarjetaBody(noticia: noticia),
          const SizedBox(height: 10),
          const Divider(),
        ],
      ),
    );
  }

  void _abrirNoticia(BuildContext context, String url) async {
    if (url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      try {
        await launchUrl(uri);
      } catch (e) {
        print('Error launching URL: $e');
        NotificationsService.showSnackbar(
          AppLocalizations.of(context)!.errorOpeningNews,
        );
      }
    }
  }
}

class _FavoriteButton extends StatefulWidget {
  final Article noticia;
  final ThemeData currentTheme;

  const _FavoriteButton({required this.noticia, required this.currentTheme});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseDatabase.instance
          .ref('users/${user.uid}/favorites')
          .orderByChild('title')
          .equalTo(widget.noticia.title)
          .get();

      setState(() {
        isFavorite = snapshot.value != null;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;
    if (isFavorite) {
      await _removeFavorite(userId, widget.noticia.title);
      setState(() => isFavorite = false);
    } else {
      await _addFavorite(userId, widget.noticia);
      setState(() => isFavorite = true);
    }
  }

  Future<void> _addFavorite(String userId, Article noticia) async {
    try {
      await FirebaseDatabase.instance
          .ref('users/$userId/favorites')
          .push()
          .set({
        'title': noticia.title,
        'description': noticia.description,
        'url': noticia.url,
        'urlToImage': noticia.urlToImage,
        'source': noticia.source.name,
      });
    } catch (e) {
      print('Error adding favorite: $e');
      NotificationsService.showSnackbar('Error adding favorite.');
    }
  }

  Future<void> _removeFavorite(String userId, String noticiaTitle) async {
    final snapshot = await FirebaseDatabase.instance
        .ref('users/$userId/favorites')
        .orderByChild('title')
        .equalTo(noticiaTitle)
        .get();

    if (snapshot.value != null) {
      final Map favorites = snapshot.value as Map;
      for (var key in favorites.keys) {
        if (favorites[key]['title'] == noticiaTitle) {
          await FirebaseDatabase.instance.ref('users/$userId/favorites/$key').remove();
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: RawMaterialButton(
        constraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        onPressed: _toggleFavorite,
        child: Icon(
          isFavorite ? Icons.star : Icons.star_border,
          color: isFavorite ? Colors.yellow : Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _TarjetaBody extends StatelessWidget {
  final Article noticia;

  const _TarjetaBody({required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        noticia.description ?? '',
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class _TarjetaImagen extends StatelessWidget {
  final Article noticia;

  const _TarjetaImagen({required this.noticia});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final String url = noticia.url;
        if (url.isNotEmpty) {
          final Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se puede abrir el enlace')),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: FadeInImage(
            placeholder: const AssetImage('assets/giphy.gif'),
            image: NetworkImage(noticia.urlToImage ?? ''),
            imageErrorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _TarjetaTopBar extends StatelessWidget {
  final Article noticia;
  final int index;

  const _TarjetaTopBar({required this.noticia, required this.index});

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ',
            style: TextStyle(color: currentTheme.colorScheme.primary),
          ),
          Expanded(child: Text('${noticia.source.name}. ')),
        ],
      ),
    );
  }
}

class _TarjetaTitulo extends StatelessWidget {
  final Article noticia;

  const _TarjetaTitulo({required this.noticia});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              noticia.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        // Mostrar el botón de favoritos solo si el usuario está autenticado
        if (user != null) _FavoriteButton(
          noticia: noticia,
          currentTheme: Provider.of<ThemeProvider>(context).currentTheme,
        ),
      ],
    );
  }
}
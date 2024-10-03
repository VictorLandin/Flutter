import 'package:flutter/material.dart';
import 'package:noticias/models/news_models.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Importar url_launcher
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/notifications_service.dart';

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
    return Column(
      children: [
        _TarjetaTopBar(noticia: noticia, index: index),
        _TarjetaTitulo(noticia: noticia),
        if (noticia.urlToImage != null)
          _TarjetaImagen(noticia: noticia),
        _TarjetaBody(noticia: noticia),
        _TarjetaBotones(noticia: noticia),  // Pasar noticia al botón de favoritos
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

class _TarjetaBotones extends StatefulWidget {
  final Article noticia;

  const _TarjetaBotones({required this.noticia});

  @override
  State<_TarjetaBotones> createState() => _TarjetaBotonesState();
}

class _TarjetaBotonesState extends State<_TarjetaBotones> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Aquí puedes verificar si la noticia está en favoritos al iniciar
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .where('title', isEqualTo: widget.noticia.title)
          .get();
      setState(() {
        isFavorite = snapshot.docs.isNotEmpty; // Si hay documentos, es favorito
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón de favoritos
        _favoriteButton(currentTheme),
        const SizedBox(width: 10),

        // Botón de abrir URL
        RawMaterialButton(
          onPressed: () async {
            final String url = widget.noticia.url;
            if (url.isNotEmpty) {
              final Uri uri = Uri.parse(url);
              try {
                  await launchUrl(uri);
              } catch (e) {
                print('Error launching URL: $e'); // Imprime el error en la consola
              }
            } else {
              print('Invalid URL: $url'); // Imprime si la URL es inválida
            }
          },
          fillColor: Colors.blue,
          shape: const StadiumBorder(),
          child: const Icon(Icons.more),
        ),
      ],
    );
  }

  RawMaterialButton _favoriteButton(ThemeData currentTheme) {
    return RawMaterialButton(
      onPressed: () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userId = user.uid;
          if (isFavorite) {
            // Eliminar de favoritos
            await _removeFavorite(userId, widget.noticia.title);
            setState(() {
              isFavorite = false;
            });
          } else {
            // Añadir a favoritos
            await _addFavorite(userId, widget.noticia);
            setState(() {
              isFavorite = true;
            });
          }
        } else {
          NotificationsService.showSnackbar('Please login first');
        }
      },
      fillColor: currentTheme.colorScheme.primary,
      shape: const StadiumBorder(),
      child: Icon(
        isFavorite ? Icons.star : Icons.star_border,
        color: isFavorite ? Colors.yellow : Colors.white,
      ),
    );
  }

  Future<void> _addFavorite(String userId, Article noticia) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .add({
      'title': noticia.title,
      'description': noticia.description,
      'url': noticia.url,
      'urlToImage': noticia.urlToImage,
      'source': noticia.source.name,
    });
  }

  Future<void> _removeFavorite(String userId, String noticiaTitle) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .where('title', isEqualTo: noticiaTitle)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        child: FadeInImage(
          placeholder: const AssetImage('assets/giphy.gif'), // Imagen de carga
          image: NetworkImage(noticia.urlToImage ?? ''), // Cambia esto si tienes la URL directa
          imageErrorBuilder: (context, error, stackTrace) {
            return const SizedBox(width: 0, height: 0); // retorna widget vacio si hay error
          },
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
        children: [
          Text(
            '${index + 1}. ',
            style: TextStyle(color: currentTheme.colorScheme.primary),
          ),
          Text('${noticia.source.name}. '),
        ],
      ),
    );
  }
}

class _TarjetaTitulo extends StatelessWidget {
  final dynamic noticia;

  const _TarjetaTitulo({required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        noticia.title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
    );
  }
}

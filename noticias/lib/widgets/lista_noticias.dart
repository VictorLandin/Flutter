import 'package:flutter/material.dart';
import 'package:noticias/models/news_models.dart';

import '../theme/theme.dart';

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
          _TarjetaImagen(noticia: noticia), // Conditional image display
        _TarjetaBody(noticia: noticia),
        _TarjetaBotones(),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

class _TarjetaBotones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RawMaterialButton(
          onPressed: () {},
          fillColor: myTheme.colorScheme.primary,
          shape: const StadiumBorder(),
          child: const Icon(Icons.star_border),
        ),
        const SizedBox(width: 10),
        RawMaterialButton(
          onPressed: () {},
          fillColor: myTheme.colorScheme.secondary,
          shape: const StadiumBorder(),
          child: const Icon(Icons.more),
        ),
      ],
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        child: FadeInImage(
          placeholder: const AssetImage('assets/giphy.gif'),
          image: NetworkImage(noticia.urlToImage!),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '${index + 1}. ',
            style: TextStyle(color: myTheme.colorScheme.primary),
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

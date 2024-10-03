import 'package:flutter/material.dart';
import 'package:noticias/models/category_model.dart';
import 'package:noticias/widgets/lista_noticias.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

import '../services/news_service.dart';
import '../theme/theme.dart';

class Tab2Screen extends StatelessWidget {
  const Tab2Screen({super.key});


  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const _ListaCategorias(),
            Expanded(
              child: Scaffold(
                body: (newsService.getArticulosCategoriaSeleccionada.isEmpty)
                    ? const Center(child: CircularProgressIndicator())
                    : ListaNoticias(newsService.getArticulosCategoriaSeleccionada),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaCategorias extends StatelessWidget {
  const _ListaCategorias({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<NewsService>(context).categories;

    return SizedBox(
      width: double.infinity,
      height: 95,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: _CategoryButton(categoria: categories[index]),
          );
        },
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({super.key, required this.categoria});

  final CategoryNews categoria;

  @override
  Widget build(BuildContext context) {

    ThemeData currentTheme = Provider.of<ThemeProvider>(context).currentTheme;
    final categoriaSeleccionada = Provider.of<NewsService>(context).selectedCategory;

    return GestureDetector(
      onTap: () {
        final newsService = Provider.of<NewsService>(context, listen: false);
        newsService.selectedCategory = categoria.name;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,  // Center items vertically
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (categoria.name == categoriaSeleccionada)
                  ? currentTheme.colorScheme.primary.withOpacity(0.2)
                  : null,
            ),
            child: Icon(
              categoria.icon,
              color: (categoria.name == categoriaSeleccionada)
                  ? currentTheme.colorScheme.primary
                  : Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            categoria.name,
            style: TextStyle(
              color: (categoria.name == categoriaSeleccionada)
                  ? currentTheme.colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

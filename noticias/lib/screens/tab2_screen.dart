import 'package:flutter/material.dart';
import 'package:noticias/models/category_model.dart';
import 'package:noticias/widgets/lista_noticias.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

import '../services/news_service.dart';
import '../theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Ajusta el ancho que deseas para cada botón de categoría
          const double categoryButtonWidth = 120.0;

          // Verifica si el espacio disponible es suficiente para mostrar todas las categorías sin scroll
          final isScrollable = constraints.maxWidth < (categories.length * categoryButtonWidth);

          if (isScrollable) {
            // Si no hay suficiente espacio, usa `SingleChildScrollView` para hacer scroll horizontal
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: _CategoryButton(categoria: category),
                  );
                }).toList(),
              ),
            );
          } else {
            // Si hay suficiente espacio, usa `Wrap` para distribuir equitativamente
            return Wrap(
              alignment: WrapAlignment.spaceBetween, // Distribuye equitativamente
              children: categories.map((category) {
                return SizedBox(
                  width: categoryButtonWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _CategoryButton(categoria: category),
                  ),
                );
              }).toList(),
            );
          }
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
    final localization = AppLocalizations.of(context)!;

    // Traducción basada en el id de la categoría
    final translatedName = _translateCategory(localization, categoria.id);

    return GestureDetector(
      onTap: () {
        final newsService = Provider.of<NewsService>(context, listen: false);
        newsService.selectedCategory = categoria.id;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (categoria.id == categoriaSeleccionada)
                  ? currentTheme.colorScheme.primary.withOpacity(0.2)
                  : null,
            ),
            child: Icon(
              categoria.icon,
              color: (categoria.id == categoriaSeleccionada)
                  ? currentTheme.colorScheme.primary
                  : Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            translatedName,
            style: TextStyle(
              color: (categoria.id == categoriaSeleccionada)
                  ? currentTheme.colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

String _translateCategory(AppLocalizations localization, String categoryId) {
  switch (categoryId) {
    case 'business':
      return localization.business;
    case 'entertainment':
      return localization.entertainment;
    case 'health':
      return localization.health;
    case 'science':
      return localization.science;
    case 'sports':
      return localization.sports;
    case 'technology':
      return localization.technology;
    default:
      return categoryId; // Devuelve el ID si no hay traducción
  }
}



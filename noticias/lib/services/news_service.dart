import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/news_models.dart';
import '../models/category_model.dart';
import 'package:http/http.dart' as http;

const _urlNews = 'https://newsapi.org/v2';
const _apikey = 'aee3de213ca24727a918cc0f771871e7';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'business'; // Identificador de la categoría seleccionada

  // Define las categorías con identificadores únicos
  List<CategoryNews> categories = [
    const CategoryNews(id: 'business', icon: FontAwesomeIcons.building),
    const CategoryNews(id: 'entertainment', icon: FontAwesomeIcons.tv),
    const CategoryNews(id: 'health', icon: FontAwesomeIcons.addressCard),
    const CategoryNews(id: 'science', icon: FontAwesomeIcons.headSideVirus),
    const CategoryNews(id: 'sports', icon: FontAwesomeIcons.futbol),
    const CategoryNews(id: 'technology', icon: FontAwesomeIcons.memory),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    getTopHeadlines();
    for (var item in categories) {
      categoryArticles[item.id] = [];
    }
    getArticlesByCategory(_selectedCategory);
  }

  String get selectedCategory => _selectedCategory;

  set selectedCategory(String value) {
    _selectedCategory = value;
    getArticlesByCategory(value);
    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada => categoryArticles[_selectedCategory]!;

  getTopHeadlines() async {
    const url = '$_urlNews/top-headlines?country=us&apiKey=$_apikey';
    final resp = await http.get(Uri.parse(url));
    final newsResponse = NewsResponse.fromJson(resp.body);

    // Filtra los artículos antes de agregarlos a headlines
    for (var article in newsResponse.articles) {
      if (_isValidArticle(article)) {
        headlines.add(article);
      }
    }

    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (categoryArticles[category]!.isNotEmpty) {
      return categoryArticles[category];
    }
    final url = '$_urlNews/top-headlines?country=us&category=$category&apiKey=$_apikey';
    final resp = await http.get(Uri.parse(url));
    final newsResponse = NewsResponse.fromJson(resp.body);

    // Filtra los artículos antes de agregarlos a categoryArticles
    for (var article in newsResponse.articles) {
      if (_isValidArticle(article)) {
        categoryArticles[category]?.add(article);
      }
    }

    notifyListeners();
  }

  // Función para verificar si el artículo es válido, no es valido si cualquiera de sus valores es [removed]
  bool _isValidArticle(Article article) {
    if (article.description == '[Removed]' || article.title == '[Removed]') {
      return false;
    }
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:noticias/widgets/lista_noticias.dart';
import 'package:provider/provider.dart';

import '../services/news_service.dart';

class Tab1Screen extends StatefulWidget {
  const Tab1Screen({super.key});

  @override
  State<Tab1Screen> createState() => _Tab1ScreenState();
}

class _Tab1ScreenState extends State<Tab1Screen> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final newsService = Provider.of<NewsService>(context);
    return SafeArea(
      child: Scaffold(
        body: (newsService.headlines.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : ListaNoticias(newsService.headlines),
      ),
    );
  }

  @override
	bool get wantKeepAlive => true;
}

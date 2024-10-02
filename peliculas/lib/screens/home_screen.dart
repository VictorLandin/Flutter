import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movies_provider.dart';
import '../widgets/widgets.dart';
import '../search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        actions: [
          IconButton(onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
							icon: Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          CardSwiper(movies: moviesProvider.onDisplayMovies),
          MovieSlider(
            movies: moviesProvider.popularMovies,
            title: 'Populares!',
            onNextPage: () => moviesProvider.getPopularMovies(),
          ),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/models.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        height: 400,
        margin: const EdgeInsets.only(bottom: 30, top: 50),
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(url: product.picture),
            _ProductDetails(
              title: product.name,
              subtitle: product.id!,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(
                price: product.price,
              ),
            ),
            if (!product.available)
              Positioned(
                top: 0,
                left: 0,
                child: _NotAvailable(),
              )
          ],
        ),
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 70,
        decoration: BoxDecoration(
            color: Colors.yellow[800],
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(25),
                topLeft: Radius.circular(25))),
        child: const FittedBox(
            fit: BoxFit.contain,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'No disponible',
                ))));
  }
}

class _PriceTag extends StatelessWidget {
  final double price;

  const _PriceTag({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$$price',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ProductDetails(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ]),
        ));
  }
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage({this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        foregroundDecoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(25),
        ),
        child: url == null
            ? const Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              )
            : FadeInImage(
                placeholder: const AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(
                    url ?? 'https://via.placeholder.com/400x300/f6f6f6'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 7))
        ]);

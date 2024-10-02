import 'dart:io';

import 'package:flutter/material.dart';


class ProductImage extends StatelessWidget {
  final String? url;

  const ProductImage({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: _buildBoxDecoration(),
        child: Opacity(
          opacity: 0.8,
          child: getImage(url),
        ),
      ),
    );
  }
}

BoxDecoration _buildBoxDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black, Colors.transparent]),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(45),
      topRight: Radius.circular(45),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  );
}

Widget getImage(String? picture) {
  if (picture == null) {
    return const Image(
      image: AssetImage('assets/no-image.png'),
    );
  } else if (picture.startsWith('http')) {
    return FadeInImage(
      placeholder: const AssetImage('assets/jar-loading.gif'),
      image: NetworkImage(picture),
      fit: BoxFit.cover,
    );
  } else {
    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }
}

import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class CustomCardType1 extends StatelessWidget {
  const CustomCardType1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        const ListTile(
          leading: Icon(
            Icons.photo_album_outlined,
            color: AppTheme.primary,
          ),
          title: Text('Soy un titulo'),
          subtitle: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed euismod, nisl nec aliquam consectetur, nunc felis vehicula dui, vel sodales risus nunc at magna. Aenean et nulla euismod, imperdiet nisi ut, malesuada nibh. Sed vitae nisl nec nulla viverra dignissim. Mauris et nisl nec nulla viverra dignissim. Sed vitae nisl nec nulla viverra dignissim. Mauris et nisl nec nulla viverra dignissim.'),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {}, child: const Text('Cancel')),
              TextButton(onPressed: () {}, child: const Text('Ok')),
            ],
          ),
        )
      ]),
    );
  }
}

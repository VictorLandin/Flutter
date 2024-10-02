import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  double _sliderValue = 100;
  bool _sliderEnable = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slider & Checks'),
      ),
      body: Column(children: [
        Slider.adaptive(
            min: 50,
            max: 400,
            activeColor: AppTheme.primary,
            value: _sliderValue,
            onChanged: _sliderEnable
                ? (value) {
                    _sliderValue = value;
                    setState(() {});
                  }
                : null),
       /* Checkbox(
            activeColor: AppTheme.primary,
            value: _sliderEnable,
            onChanged: (value) {
              _sliderEnable = value ?? true;
              setState(() {});
            }),
				Switch(
						activeColor: AppTheme.primary,
						value: _sliderEnable,
						onChanged: (value) {
							_sliderEnable = value;
							setState(() {});
						}),*/

        CheckboxListTile.adaptive(
            activeColor: AppTheme.primary,
            title: const Text('Habilitar Slider'),
            value: _sliderEnable,
            onChanged: (value) => setState(() {
                  _sliderEnable = value ?? true;
                })),

				SwitchListTile.adaptive(
						activeColor: AppTheme.primary,
						title: const Text('Habilitar Slider'),
						value: _sliderEnable,
						onChanged: (value) => setState(() {
									_sliderEnable = value;
								})),


				const AboutListTile(),

        Expanded(
          child: SingleChildScrollView(
            child: Image(
                image: const NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/b/b6/Batman_cosplay.png'),
                width: _sliderValue,
                fit: BoxFit.contain),
          ),
        ),
      ]),
    );
  }
}

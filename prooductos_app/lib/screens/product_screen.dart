import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prooductos_app/providers/product_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../providers/providers.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
        create: (_) => ProductFormProvider(productsService.selectedProduct),
        child: _ProductScreenBody(productsService: productsService));
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    super.key,
    required this.productsService,
  });

  final ProductsService productsService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              SafeArea(
                child: Stack(children: [
                  ProductImage(url: productsService.selectedProduct.picture),
                  Positioned(
                      top: 20,
                      left: 20,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                        iconSize: 40,
                        color: Colors.white,
                      )),
                  Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        onPressed: () async {
                          final picker = new ImagePicker();
                          final XFile? pickedFile = await picker.pickImage(
                              source: ImageSource.camera,
                            imageQuality: 100
                          );

                          if (pickedFile == null) {
                            print('No selecciono nada');
                            return;
                          }
                          productsService.updateSelectedProductImage(pickedFile.path);
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.white,
                        ),
                      ))
                ]),
              ),
              _ProductForm(),
              const SizedBox(height: 100),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
    elevation: 0,
    shape: const StadiumBorder(),
    heroTag: 'btn1',
    backgroundColor: Colors.deepPurple,
    child: productsService.isSaving ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.save_outlined, color: Colors.white),
    onPressed: () async {
    if ( !productForm.isValidForm()) return;
    final String? imageUrl = await productsService.uploadImage();
    await productsService.saveOrCreateProduct(productForm.product);
    },
  ));
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: _buildBoxDecoration(),
            child: Form(
                key: productForm.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    TextFormField(
                      initialValue: product.name,
                      onChanged: (value) => product.name = value,
                      validator: (value) {
                        if (value == null || value.length < 1) {
                          return 'El nombre es obligatorio';
                        }
                      },
                      decoration: InputDecorations.authInputDecoration(
                        hintText: 'Nombre del producto',
                        labelText: 'Nombre:',
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      initialValue: product.price.toString(),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                      ],
                      onChanged: (value) {
                        if (double.tryParse(value) == null) {
                          product.price = 0;
                        } else {
                          product.price = double.parse(value);
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecorations.authInputDecoration(
                        hintText: '\$150',
                        labelText: 'Precio:',
                      ),
                    ),
                    const SizedBox(height: 30),
                    SwitchListTile(
                      value: product.available,
                      title: const Text('Disponible'),
                      activeColor: Colors.deepPurple,
                      onChanged: productForm.updateAvailability,
                    ),
                    const SizedBox(height: 30),
                  ],
                ))));
  }
}

BoxDecoration _buildBoxDecoration() {
  return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5)
      ]);
}

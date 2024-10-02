import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-47a17-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  late Product selectedProduct;

  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  // Method to load all products
  Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();

    // Retrieve the token from secure storage
    final String? token = await storage.read(key: 'token');
    if (token == null) {
      print('Error: No token found');
      this.isLoading = false;
      notifyListeners();
      return [];
    }

    final url = Uri.https(_baseUrl, 'products.json', {'auth': token});
    final resp = await http.get(url);

    try {
      final Map<String, dynamic> productsMap = json.decode(resp.body);

      // Clear previous product list to avoid duplication
      products.clear();

      productsMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          final tempProduct = Product.fromMap(value);
          tempProduct.id = key;
          products.add(tempProduct);
        }
      });

      this.isLoading = false;
      notifyListeners();
      return this.products;
    } catch (e) {
      print('Error decoding response: $e');
      this.isLoading = false;
      notifyListeners();
      return [];
    }
  }

  // Save or create a product
  Future<void> saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  // Update an existing product
  Future<String> updateProduct(Product product) async {
    final String? token = await storage.read(key: 'token');
    if (token == null) {
      print('Error: No token found');
      return 'Error';
    }

    final url = Uri.https(_baseUrl, 'products/${product.id}.json', {'auth': token});
    final resp = await http.put(url, body: product.toJson());

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  // Create a new product
  Future<String> createProduct(Product product) async {
    final String? token = await storage.read(key: 'token');
    if (token == null) {
      print('Error: No token found');
      return 'Error';
    }

    final url = Uri.https(_baseUrl, 'products.json', {'auth': token});
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);

    if (decodedData['name'] != null) {
      product.id = decodedData['name'];
      products.add(product);
      return product.id!;
    } else {
      throw Exception('Failed to create product. ID not returned from the API.');
    }
  }

  // Update the selected product image
  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  // Upload an image to Cloudinary
  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dawtgh7bx/image/upload?upload_preset=yxmhbfxz'
    );

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Image upload failed: ${resp.body}');
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}

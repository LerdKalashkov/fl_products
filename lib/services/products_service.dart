// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-products-c9c2c-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
    final storage = const FlutterSecureStorage();


  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, '/products/.json', {
      'auth' : await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future createProduct(Product product) async {
    final url = Uri.https(_baseUrl, '/products/.json', {
      'auth' : await storage.read(key: 'idToken') ?? ''
    });
        //create a future getter for returnSecureToken.
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);

    product.id = decodedData['name'];
    products.add(product);
    notifyListeners();
    return product.id;
  }
  
  Future updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, '/products/${product.id}.json', {
      'auth' : await storage.read(key: 'idToken') ?? ''
    });
    //create a future getter for returnSecureToken.
    final resp = await http.put(url, body: product.toJson());
    // ignore: unused_local_variable
    final decodedData = resp.body;

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id;
  }


  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;
    isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/degrgsqsn/image/upload?upload_preset=f5ytonbd');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Something\'s Wrong :( ');
      print(resp.body);
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}

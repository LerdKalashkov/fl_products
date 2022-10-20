import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Product product;
  ProductFormProvider(this.product);

  updateAvalaibility(bool value) {
    product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    // ignore: avoid_print
    print(product.name);
    // ignore: avoid_print
    print(product.price);
    // ignore: avoid_print
    print(product.available);

    return formkey.currentState?.validate() ?? false;
  }
}

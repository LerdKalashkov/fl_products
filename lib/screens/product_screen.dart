import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:fl_products/providers/product_form_provider.dart';
import 'package:flutter/services.dart';

import 'package:fl_products/widgets/widgets.dart';
import 'package:fl_products/services/products_service.dart';
import 'package:fl_products/ui/input_decorations.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreen(productService: productService),
    );
  }
}

class _ProductScreen extends StatelessWidget {
  const _ProductScreen({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(children: [
            ProductImage(url: productService.selectedProduct.picture),
            Positioned(
                top: 40,
                left: 30,
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        size: 40, color: Colors.white))),
            Positioned(
                top: 40,
                right: 40,
                child: IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 50);

                      if (pickedFile == null) {
                        // ignore: avoid_print
                        print('Error Image');
                        return;
                      }
                      // ignore: avoid_print
                      print('Done image! ${pickedFile.path}');
                      productService
                          .updateSelectedProductImage(pickedFile.path);
                    },
                    icon: const Icon(Icons.camera_alt,
                        size: 40, color: Colors.white)))
          ]),

          _ProductForm(),

          const SizedBox(height: 100),
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          if (!productForm.isValidForm()) return;
          final String? imageUrl = await productService.uploadImage();

          if (imageUrl != null) productForm.product.picture = imageUrl;
          await productService.saveOrCreateProduct(productForm.product);

        },
        child: const Icon(Icons.save),
      ),
    );
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
        decoration: _buildBoxDecoration(),
        child: Form(
            key: productForm.formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextFormField(
                      initialValue: product.name,
                      onChanged: ((value) => product.name = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'The name is required';
                        }
                        return null;
                      },
                      decoration: InputDecorations.authInputDecoration(
                          hintText: 'Product Name', labelText: 'Name')),
                  const SizedBox(height: 20),
                  TextFormField(
                      initialValue: '${product.price}',
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
                          hintText: '\$150.00', labelText: 'Price')),
                  const SizedBox(height: 20),
                  SwitchListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text(
                        'Available',
                        style: TextStyle(color: Colors.grey),
                      ),
                      activeColor: Colors.indigo,
                      value: product.available,
                      onChanged: (value) =>
                          productForm.updateAvalaibility(value)),
                  const SizedBox(height: 30),
                ],
              ),
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(45),
            bottomLeft: Radius.circular(45),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
              blurRadius: 5,
            )
          ]);
}

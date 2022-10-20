import 'package:flutter/material.dart';
import 'package:fl_products/screens/screens.dart';
import 'package:fl_products/widgets/widgets.dart';
import 'package:fl_products/models/models.dart';

import 'package:fl_products/services/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Products')), 
      actions: [
        IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
                  authService.logout();
                  Navigator.pushReplacementNamed(context, 'login');
                })
      ]),
      body: ListView.builder(
          itemCount: productsService.products.length,
          itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'product');
                productsService.selectedProduct =
                    productsService.products[index].copy();
              },
              child: ProductCard(
                product: productsService.products[index],
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productsService.selectedProduct =
              Product(available: true, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}

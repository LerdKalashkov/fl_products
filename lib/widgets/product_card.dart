import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: _cardBorders(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          _BackgroundImage(url: product.picture),
          _ProductDetails(
            subTitle: product.id!,
            title: product.name,
          ),
          Positioned(top: 0, right: 0, child: _PriceTag(price: product.price)),
          if (!product.available)
            Positioned(top: 0, left: 0, child: _NoAvaible())
        ],
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 5),
          blurRadius: 10,
        )
      ],
      borderRadius: BorderRadius.circular(25),
    );
  }
}

class _NoAvaible extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        width: 130,
        height: 61,
        decoration: _noAvaibleStyle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'No Available',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _noAvaibleStyle() => const BoxDecoration(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(45),
        bottomRight: Radius.circular(45),
        topLeft: Radius.circular(25),
      ),
      color: Colors.amber);
}

// ignore: must_be_immutable
class _BackgroundImage extends StatelessWidget {
  String? url;
  _BackgroundImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: url == null

        ? const Image(
          image: AssetImage('assets/no-image.png'),
          fit: BoxFit.cover)

        : FadeInImage(
          image: NetworkImage(url!),
          placeholder: const AssetImage('assets/loading.gif'))
          
      )
    );
  }
}

class _PriceTag extends StatelessWidget {
  final double price;

  const _PriceTag({required this.price});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        width: 130,
        height: 61,
        decoration: _priceTagStyle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$price',
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _priceTagStyle() => const BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(45),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(45)),
      color: Colors.indigo);
}

class _ProductDetails extends StatelessWidget {
  final String title;
  final String subTitle;

  const _ProductDetails({required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 150),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 75,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subTitle,
              style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(45),
          bottomRight: Radius.circular(45),
          bottomLeft: Radius.circular(25)),
      color: Colors.indigo);
}

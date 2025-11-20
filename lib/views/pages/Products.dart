import 'package:babivision/Utils/Utils.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/views/IconMessage.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/loadingIndicators/StackLoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductDelegate extends StatelessWidget {
  final int id;
  final String name;
  final double price;
  final int discount;
  final int stock;
  final String? image;
  const ProductDelegate({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.stock,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 6,
            spreadRadius: 0,
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.23),
            blurRadius: 6,
            spreadRadius: 0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: B(
              inExpanded: true,
              child: Image.network(
                image ?? "",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
                errorBuilder: (_, _, _) {
                  return Container(
                    color: Colors.grey,
                    width: double.infinity,
                    child: Icon(Icons.image_not_supported_outlined, size: 50),
                  );
                },
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey,
                    width: double.infinity,
                    child: Center(child: SpinKitPulse(color: Colors.purple)),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: B(
              inExpanded: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: context.fontSizeMin(16)),
                    ),
                    Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "USD $price",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: context.fontSizeMin(13),
                              ),
                            ),
                            Text(
                              "USD ${price + price * discount / 100}",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.grey,
                                fontSize: context.fontSizeMin(13),
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductGrid extends StatefulWidget {
  final List items;
  const ProductGrid({super.key, required this.items});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.items.length,
      padding: context.responsive(sm: EdgeInsets.all(8), lg: EdgeInsets.zero),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsive(sm: 2, md: 3, lg: 4),
        childAspectRatio: .7,
        mainAxisSpacing: context.responsive(sm: 10, md: 15),
        crossAxisSpacing: context.responsive(sm: 10, md: 15),
      ),
      itemBuilder: (context, index) {
        return ProductDelegate(
          id: 1,
          name: "Sample Glasses",
          price: 25,
          discount: 0,
          stock: 15,
          image: serverAsset(
            "/storage/product_images/glasses/sample-1-black.jpg",
          ),
        );
      },
    );
  }
}

class Products extends StatefulWidget {
  final String? category;
  const Products({super.key, this.category});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool _isLoading = false, _isError = false;

  @override
  Widget build(BuildContext context) {
    Widget content = const SizedBox.shrink();

    if (_isLoading)
      content = StackLoadingIndicator(
        indicator: SpinKitDoubleBounce(color: Colors.purple),
      );
    else if (_isError)
      content = Center(child: IconMessage.error());
    else
      content = Center(
        child: B(
          child: SizedBox(
            width: double.infinity.max(1000),
            child: ProductGrid(
              items: List.generate(1000, (index) => index + 1),
            ),
          ),
        ),
      );

    return Scaffold(
      backgroundColor: KColors.offWhite10,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: const Text(
          "Products",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: content,
    );
  }
}

import 'package:babivision/Utils/Http.dart';
import 'package:babivision/Utils/Utils.dart';
import 'package:babivision/Utils/extenstions/ResponsiveContext.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/models/Product.dart';
import 'package:babivision/views/Future/SkeletonWidget.dart';
import 'package:babivision/views/IconMessage.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/loadingIndicators/StackLoadingIndicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    final finalPrice = (price - price * (discount / 100)).toStringAsFixed(1);

    double priceFontSize = context.responsive(
      sm: context.fontSizeMin(11, maxWidth: 1000),
      lg: context.fontSizeMin(13, maxWidth: 1000),
    );
    return Container(
      decoration: const BoxDecoration(
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
            flex: 55,
            child: CachedNetworkImage(
              imageUrl: image ?? "",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
              errorWidget: (_, _, _) {
                return Container(
                  color: Colors.grey,
                  width: double.infinity,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 50,
                  ),
                );
              },
              placeholder: (_, child) {
                return Container(
                  color: Colors.grey,
                  width: double.infinity,
                  child: const Center(
                    child: SpinKitPulse(color: Colors.purple),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 45,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: context.fontSizeMin(16, maxWidth: 1000),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "USD $finalPrice",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: priceFontSize,
                            ),
                          ),
                          if (discount > 0)
                            Text(
                              "USD $price",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.grey,
                                fontSize: priceFontSize,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      if (discount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "$discount%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: priceFontSize,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Center(
                    child: FilledButton.icon(
                      onPressed: () {},
                      label: Text(
                        "Buy Now",
                        style: TextStyle(
                          fontSize: context.fontSizeMin(16, maxWidth: 1000),
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Container(
    //   color: Colors.red,
    //   height: 200,
    //   width: 200,
    //   child: Center(child: Text("$id")),
    // );
  }
}

class ProductGrid extends StatefulWidget {
  final List items;
  final ScrollController controller;
  const ProductGrid({super.key, required this.items, required this.controller});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.controller.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: Colors.blue[900]!,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: GridView.builder(
          itemCount: widget.items.length,
          //cacheExtent: 1000,
          addAutomaticKeepAlives: true,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.controller,
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                context.responsiveExplicit(
                  fallback: 2,
                  onRatio: {.8: 3, 1.2: 4, 1.7: 5},
                )!,
            childAspectRatio: .7,
            mainAxisSpacing: context.responsive(sm: 10, md: 15),
            crossAxisSpacing: context.responsive(sm: 10, md: 15),
          ),
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final Product product = Product.fromJSON(item);
            return SkeletonWidget(
              durationInMilliseconds: 500,
              skeleton: const SizedBox(
                child: Center(child: Icon(Icons.hourglass_bottom)),
              ),
              child: ProductDelegate(
                id: product.id,
                name: product.name,
                price: product.price,
                discount: product.discount,
                stock: product.stock,
                image: serverAsset(product.image),
              ),
            );
          },
        ),
      ),
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
  List? _products;
  final ScrollController controller = ScrollController();

  Future<void> _fetchProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });
      debugPrint("fetching /api/products/${widget.category}");
      final response = await Http.get("/api/products/${widget.category ?? ''}");
      final products = response.data['products'];
      setState(() {
        _isLoading = false;
        _products = products;
      });
    } catch (_) {
      if (mounted)
        setState(() {
          _isLoading = false;
          _isError = true;
        });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const SizedBox.shrink();

    if (_isLoading)
      content = StackLoadingIndicator(
        indicator: SpinKitDoubleBounce(color: Colors.purple),
      );
    else if (_isError)
      content = Center(child: IconMessage.error());
    else if (_products == null || _products!.isEmpty)
      content = Center(
        child: IconMessage(
          icon: Icons.shopping_cart_rounded,
          message: "No products found!",
          color: KColors.profileBlue,
          scalableSize: 24,
        ),
      );
    else
      content = Scrollbar(
        thickness: context.responsive(sm: 5, lg: 10),
        trackVisibility: context.responsive(sm: false, lg: true),
        thumbVisibility: true,
        interactive: true,
        scrollbarOrientation: ScrollbarOrientation.right,
        controller: controller,
        child: Center(
          child: SizedBox(
            width: double.infinity.max(1000),
            child: ProductGrid(controller: controller, items: _products!),
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

import 'package:flutter/material.dart';

class LazyImage extends StatefulWidget {
  final String src;
  final double? width;
  final double? height;
  const LazyImage({super.key, required this.src, this.width, this.height});

  @override
  State<LazyImage> createState() => _LazyImageState();
}

class _LazyImageState extends State<LazyImage> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.src,
      width: widget.width,
      height: widget.height,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

class SkeletonWidget extends StatefulWidget {
  final int durationInMilliseconds;
  final Widget skeleton;
  final Widget child;
  const SkeletonWidget({
    super.key,
    required this.durationInMilliseconds,
    required this.skeleton,
    required this.child,
  });

  @override
  State<SkeletonWidget> createState() => _SkeletonWidgetState();
}

class _SkeletonWidgetState extends State<SkeletonWidget> {
  bool _isLoading = true;
  Timer? _timer;

  void _buildWithSkeleton() async {
    setState(() {
      _isLoading = true;
    });
    _timer = Timer(Duration(milliseconds: widget.durationInMilliseconds), () {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buildWithSkeleton();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? widget.skeleton : widget.child;
  }
}

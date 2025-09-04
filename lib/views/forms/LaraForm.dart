import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Laraform extends StatefulWidget {
  //A Simple form wrapper that works well with laravel validations

  final Widget child;
  final Future<Response<dynamic>> onSubmit;

  const Laraform({super.key, required this.child, required this.onSubmit});

  @override
  State<Laraform> createState() => _LaraformState();
}

class _LaraformState extends State<Laraform> {
  bool isLoading = false, isDone = false, isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(child: widget.child);
  }
}

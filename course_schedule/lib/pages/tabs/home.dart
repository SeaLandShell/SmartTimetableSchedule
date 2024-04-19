import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  final Color backgroundColor;
  const HomePage({
    Key? key,
    this.backgroundColor = Colors.black, //默认为灰色
  }):super(key:key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio=Dio();
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("111222"),
    );
  }
}

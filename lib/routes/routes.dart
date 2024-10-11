import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../tambahdata.dart';
import '../main.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => HomePage(),
    ),
    GetPage(
      name: '/tambah',
      page: () => TambahDataPage(),
    ),
  ];
}

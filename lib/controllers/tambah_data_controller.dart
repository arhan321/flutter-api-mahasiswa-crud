import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TambahDataController {
  Future<void> selectDate(
      BuildContext context, TextEditingController ttlController) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      ttlController.text = formattedDate;
    }
  }

  void tambahDataMahasiswa(
    BuildContext context,
    TextEditingController namaController,
    TextEditingController nimController,
    TextEditingController emailController,
    TextEditingController ttlController,
    TextEditingController alamatController,
    String? jenisKelamin,
    String? agama,
    String? fakultas,
    String? jurusan,
    String? status,
  ) async {
    final response = await http.post(
      Uri.parse('https://abl.djncloud.my.id/api/v1/mahasiswa'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nama_mahasiswa': namaController.text,
        'nim': nimController.text,
        'email': emailController.text,
        'ttl': ttlController.text + " 03:00:00",
        'jenis_kelamin': jenisKelamin,
        'agama': agama,
        'alamat': alamatController.text,
        'fakultas': fakultas,
        'jurusan': jurusan,
        'status': status,
      }),
    );

    if (response.statusCode == 201) {
      Get.back();
      Get.snackbar('Success', 'Data Mahasiswa berhasil ditambahkan');
    } else {
      Get.snackbar(
          'Error', 'Gagal menambahkan data mahasiswa: ${response.body}');
    }
  }
}

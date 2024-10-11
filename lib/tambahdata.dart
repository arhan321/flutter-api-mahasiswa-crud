import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import untuk format tanggal

class TambahDataPage extends StatefulWidget {
  @override
  _TambahDataPageState createState() => _TambahDataPageState();
}

class _TambahDataPageState extends State<TambahDataPage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers untuk input
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ttlController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  // Variabel untuk dropdown
  String? jenisKelamin;
  String? agama;
  String? fakultas;
  String? jurusan;
  String? status;

  // List untuk pilihan dropdown
  final List<String> jenisKelaminOptions = ['laki-laki', 'perempuan'];
  final List<String> agamaOptions = [
    'islam',
    'kristen',
    'katolik',
    'hindu',
    'budha',
    'konghucu'
  ];
  final List<String> fakultasOptions = [
    'teknik',
    'ekonomi',
    'hukum',
    'pertanian',
    'perikanan',
    'fasilkom'
  ];
  final List<String> jurusanOptions = [
    'informatika',
    'sipil',
    'mesin',
    'elektro',
    'industri'
  ];
  final List<String> statusOptions = ['aktif', 'nonaktif'];

  // Function untuk memilih tanggal menggunakan DatePicker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Tanggal default
      firstDate: DateTime(1900), // Tanggal awal
      lastDate: DateTime(2100), // Tanggal akhir
    );

    if (pickedDate != null) {
      // Format tanggal yang dipilih
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        ttlController.text = formattedDate; // Set tanggal ke controller
      });
    }
  }

  // Fungsi untuk submit data mahasiswa
  void tambahDataMahasiswa(BuildContext context) async {
    final response = await http.post(
      Uri.parse('https://abl.djncloud.my.id/api/v1/mahasiswa'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nama_mahasiswa': namaController.text,
        'nim': nimController.text,
        'email': emailController.text,
        'ttl': ttlController.text + " 03:00:00", // Tambahkan waktu pada TTL
        'jenis_kelamin': jenisKelamin,
        'agama': agama,
        'alamat': alamatController.text,
        'fakultas': fakultas,
        'jurusan': jurusan,
        'status': status,
      }),
    );

    // Log status code dan response body
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('Response Headers: ${response.headers}'); // Cek header response

    if (response.statusCode == 201) {
      Get.back(); // Kembali ke halaman sebelumnya setelah data berhasil ditambah
      Get.snackbar('Success', 'Data Mahasiswa berhasil ditambahkan');
    } else {
      Get.snackbar(
          'Error', 'Gagal menambahkan data mahasiswa: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data Mahasiswa'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nama Mahasiswa
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Mahasiswa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // NIM
              TextFormField(
                controller: nimController,
                decoration: InputDecoration(labelText: 'NIM'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIM tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // TTL dengan DatePicker
              TextFormField(
                controller: ttlController,
                readOnly: true, // Prevent user from typing manually
                decoration: InputDecoration(
                  labelText: 'TTL (Tanggal Lahir)',
                  suffixIcon: Icon(Icons.calendar_today), // Ikon untuk tanggal
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'TTL tidak boleh kosong';
                  }
                  return null;
                },
                onTap: () {
                  _selectDate(context); // Buka DatePicker ketika di-tap
                },
              ),
              SizedBox(height: 10),

              // Jenis Kelamin
              DropdownButtonFormField<String>(
                value: jenisKelamin,
                items: jenisKelaminOptions
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    jenisKelamin = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Jenis Kelamin'),
              ),
              SizedBox(height: 10),

              // Agama
              DropdownButtonFormField<String>(
                value: agama,
                items: agamaOptions
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    agama = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Agama'),
              ),
              SizedBox(height: 10),

              // Alamat
              TextFormField(
                controller: alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              // Fakultas
              DropdownButtonFormField<String>(
                value: fakultas,
                items: fakultasOptions
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    fakultas = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Fakultas'),
              ),
              SizedBox(height: 10),

              // Jurusan
              DropdownButtonFormField<String>(
                value: jurusan,
                items: jurusanOptions
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    jurusan = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Jurusan'),
              ),
              SizedBox(height: 10),

              // Status
              DropdownButtonFormField<String>(
                value: status,
                items: statusOptions
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    status = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Status'),
              ),
              SizedBox(height: 20),

              // Tombol Submit
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    tambahDataMahasiswa(context); // Lakukan submit data
                  }
                },
                child: Text('Tambah Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

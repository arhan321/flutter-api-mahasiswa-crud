import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TambahDataPage extends StatefulWidget {
  @override
  _TambahDataPageState createState() => _TambahDataPageState();
}

class _TambahDataPageState extends State<TambahDataPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ttlController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  String? jenisKelamin;
  String? agama;
  String? fakultas;
  String? jurusan;
  String? status;

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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        ttlController.text = formattedDate;
      });
    }
  }

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
        'ttl': ttlController.text + " 03:00:00",
        'jenis_kelamin': jenisKelamin,
        'agama': agama,
        'alamat': alamatController.text,
        'fakultas': fakultas,
        'jurusan': jurusan,
        'status': status,
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('Response Headers: ${response.headers}');

    if (response.statusCode == 201) {
      Get.back();
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

              TextFormField(
                controller: ttlController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'TTL (Tanggal Lahir)',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'TTL tidak boleh kosong';
                  }
                  return null;
                },
                onTap: () {
                  _selectDate(context);
                },
              ),
              SizedBox(height: 10),

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

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    tambahDataMahasiswa(context);
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tambahdata.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Get Data API Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final MahasiswaController mahasiswaController =
      Get.put(MahasiswaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Mahasiswa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (mahasiswaController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: mahasiswaController.mahasiswaList.length,
            itemBuilder: (context, index) {
              final mahasiswa = mahasiswaController.mahasiswaList[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            mahasiswa['nama_mahasiswa'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          Text(
                            'NIM: ${mahasiswa['nim']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 2),
                      SizedBox(height: 10),
                      Text(
                        'Email: ${mahasiswa['email']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'TTL: ${mahasiswa['ttl']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Jenis Kelamin: ${mahasiswa['jenis_kelamin']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Agama: ${mahasiswa['agama']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Alamat: ${mahasiswa['alamat']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Fakultas: ${mahasiswa['fakultas']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Jurusan: ${mahasiswa['jurusan']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Status: ${mahasiswa['status']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "refreshBtn",
            onPressed: () =>
                mahasiswaController.fetchMahasiswa(), // Refresh data manually
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "addDataBtn",
            onPressed: () {
              Get.to(TambahDataPage()); // Navigate to Add Data Page
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class MahasiswaController extends GetxController {
  var isLoading = true.obs;
  var mahasiswaList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMahasiswa(); // Fetch data once when initialized
  }

  void fetchMahasiswa() async {
    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse('https://abl.djncloud.my.id/api/v1/mahasiswa'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data is List) {
          mahasiswaList.assignAll(data.map((mahasiswa) {
            return {
              'nama_mahasiswa': mahasiswa['nama_mahasiswa'] ?? 'Unknown',
              'nim': mahasiswa['nim'] ?? 'Unknown',
              'email': mahasiswa['email'] ?? 'Unknown',
              'ttl': mahasiswa['ttl'] ?? 'Unknown',
              'jenis_kelamin': mahasiswa['jenis_kelamin'] ?? 'Unknown',
              'agama': mahasiswa['agama'] ?? 'Unknown',
              'alamat': mahasiswa['alamat'] ?? 'Unknown',
              'fakultas': mahasiswa['fakultas'] ?? 'Unknown',
              'jurusan': mahasiswa['jurusan'] ?? 'Unknown',
              'status': mahasiswa['status'] ?? 'Unknown',
            };
          }).toList());
        } else {
          Get.snackbar('Error', 'Unexpected response format');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/main_controller.dart';
import 'routes/routes.dart';

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
      // initialRoute: '/',
      getPages: AppRoutes.routes,
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
            onPressed: () => mahasiswaController.fetchMahasiswa(),
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "addDataBtn",
            onPressed: () {
              Get.toNamed('/tambah');
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

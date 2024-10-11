import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MahasiswaController extends GetxController {
  var isLoading = true.obs;
  var mahasiswaList = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMahasiswa();
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

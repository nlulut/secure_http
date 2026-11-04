import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  
  // [Latihan 5.b] Default timeout 10 detik
  static const Duration _defaultTimeout = Duration(seconds: 10);

  // Simulasi Login
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) {
      return 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
    } else {
      throw Exception('Email dan password tidak boleh kosong');
    }
  }

  // [Latihan 5.a] Parameter timeout opsional bertipe Duration dengan default 10 detik
  Future<List<User>> getUsers({Duration timeout = _defaultTimeout}) async {
    try {
      // [Latihan 5.b] Menggunakan .timeout(timeout) sesuai parameter
      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw HttpException('Gagal memuat data. Status: ${response.statusCode}');
      }
    } 
    // [Latihan 5.c] Menangani TimeoutException dan menampilkan pesan error sesuai
    on TimeoutException {
      throw Exception('Request timeout. Waktu tunggu koneksi server telah habis (${timeout.inSeconds} detik).');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server. Pastikan koneksi aktif.');
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }

  // Fetch Posts (Latihan 3)
  Future<List<Post>> getPosts({Duration timeout = _defaultTimeout}) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw HttpException('Gagal memuat posts. Status: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Waktu tunggu server habis (${timeout.inSeconds} detik).');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
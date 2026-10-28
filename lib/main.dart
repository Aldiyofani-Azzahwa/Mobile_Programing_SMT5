import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// ============================================================================
// 1. MODEL CLASS (Instruksi 1)
// ============================================================================
class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  // Factory fromJson sesuai struktur JSON dari reqres.in
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      avatar: json['avatar'] ?? 'https://reqres.in/img/faces/1-image.jpg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }
}

// ============================================================================
// 2. SERVICE CLASS & ERROR HANDLING (Instruksi 2 & 5)
// ============================================================================
class UserService {
  static const String _baseUrl = 'https://reqres.in/api/users';

  // READ - GET Daftar User
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?page=1'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((userJson) => UserModel.fromJson(userJson)).toList();
      } else {
        throw Exception(
          'Gagal memuat data user (Status Code: ${response.statusCode})',
        );
      }
    } on SocketException {
      throw Exception(
        'Tidak ada koneksi internet. Periksa jaringan Wi-Fi atau Data Anda.',
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // CREATE - POST Buat User Baru
  Future<Map<String, dynamic>> createUser({
    required String name,
    required String job,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'job': job}),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Gagal membuat user (Status Code: ${response.statusCode})',
        );
      }
    } on SocketException {
      throw Exception(
        'Tidak ada koneksi internet. Gagal mengirim data ke server.',
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan saat membuat user: $e');
    }
  }

  // UPDATE - PUT Perbarui Data User
  Future<Map<String, dynamic>> updateUser({
    required int id,
    required String name,
    required String job,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'job': job}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Gagal memperbarui user (Status Code: ${response.statusCode})',
        );
      }
    } on SocketException {
      throw Exception(
        'Tidak ada koneksi internet. Gagal memperbarui data.',
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan saat update user: $e');
    }
  }

  // DELETE - Hapus Data User
  Future<bool> deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id'));

      // reqres.in mengembalikan 204 (No Content) untuk DELETE, kita tangani juga 200/201
      if (response.statusCode == 204 ||
          response.statusCode == 200 ||
          response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
          'Gagal menghapus user (Status Code: ${response.statusCode})',
        );
      }
    } on SocketException {
      throw Exception(
        'Tidak ada koneksi internet. Gagal menghapus user.',
      );
    } catch (e) {
      throw Exception('Terjadi kesalahan saat menghapus user: $e');
    }
  }
}

// ============================================================================
// 3. UI, FUTUREBUILDER, & FORM CRUD (Instruksi 3 & 4)
// ============================================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum CRUD REST API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserService _userService = UserService();
  late Future<List<UserModel>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _futureUsers = _userService.getUsers();
    });
  }

  // Fungsi menampilkan SnackBar konfirmasi sukses atau error
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Dialog Form untuk Create User Baru (POST) & Edit User (PUT)
  void _showUserFormDialog({UserModel? user}) {
    final bool isEdit = user != null;
    final TextEditingController nameController = TextEditingController(
      text: isEdit ? '${user.firstName} ${user.lastName}' : '',
    );
    final TextEditingController jobController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit User (PUT)' : 'Tambah User Baru (POST)'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        hintText: 'Contoh: Budi Santoso',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Nama tidak boleh kosong'
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: jobController,
                      decoration: const InputDecoration(
                        labelText: 'Pekerjaan (Job)',
                        hintText: 'Contoh: Mobile Developer',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Pekerjaan tidak boleh kosong'
                              : null,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;

                          setDialogState(() => isSubmitting = true);

                          try {
                            if (isEdit) {
                              final result = await _userService.updateUser(
                                id: user.id,
                                name: nameController.text.trim(),
                                job: jobController.text.trim(),
                              );
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              _showSnackBar(
                                'Sukses Update (PUT): ${result['name']} - ${result['job']}',
                              );
                            } else {
                              final result = await _userService.createUser(
                                name: nameController.text.trim(),
                                job: jobController.text.trim(),
                              );
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              _showSnackBar(
                                'Sukses Create (POST)! ID: ${result['id']}, Nama: ${result['name']}',
                              );
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            _showSnackBar(
                              e.toString().replaceAll('Exception: ', ''),
                              isError: true,
                            );
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEdit ? 'Update' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialog Konfirmasi Hapus User (DELETE)
  Future<void> _confirmDelete(UserModel user) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus User (DELETE)'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${user.firstName} ${user.lastName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _userService.deleteUser(user.id);
        _showSnackBar(
          'Sukses Delete (DELETE): User ${user.firstName} (ID: ${user.id}) berhasil dihapus.',
        );
      } catch (e) {
        _showSnackBar(
          e.toString().replaceAll('Exception: ', ''),
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar User (Reqres API)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang Data',
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          // Indikator Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Mengambil data dari server...'),
                ],
              ),
            );
          }

          // Pesan Error Jelas (Termasuk saat tidak ada internet)
          if (snapshot.hasError) {
            final errorMsg =
                snapshot.error.toString().replaceAll('Exception: ', '');
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal Memuat Data',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMsg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _loadUsers,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // State Kosong
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('Tidak ada data user.'));
          }

          // Daftar User (GET)
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                  title: Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${user.email}\nID: ${user.id}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Update User (PUT)',
                        onPressed: () => _showUserFormDialog(user: user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete User (DELETE)',
                        onPressed: () => _confirmDelete(user),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUserFormDialog(),
        icon: const Icon(Icons.person_add),
        label: const Text('Tambah User'),
      ),
    );
  }
}
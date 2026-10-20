
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form Registrasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RegistrasiPage(),
    );
  }
}

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final namaFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  String? jenisKelamin;
  String? programStudi;
  bool setuju = false;

  final List<String> daftarProdi = [
    'Sistem Informasi',
    'Informatika',
    'Manajemen',
    'Akuntansi',
  ];

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();

    namaFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }

  void daftar() {
    if (!setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan setujui syarat dan ketentuan terlebih dahulu!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (jenisKelamin == null || programStudi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih jenis kelamin dan program studi!'),
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Konfirmasi Registrasi'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Nama: ${namaController.text}'),
                  const SizedBox(height: 8),
                  Text('Email: ${emailController.text}'),
                  const SizedBox(height: 8),
                  const Text('Password: ••••••'),
                  const SizedBox(height: 8),
                  Text('Jenis Kelamin: $jenisKelamin'),
                  const SizedBox(height: 8),
                  Text('Program Studi: $programStudi'),
                  const SizedBox(height: 8),
                  const Text('Syarat & Ketentuan: Disetujui'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kembali'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('Registrasi berhasil!'),
                    ),
                  );
                },
                child: const Text('Konfirmasi'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.app_registration,
                  size: 65,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Silakan isi data diri kamu',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 25),

              const Text('Nama Lengkap'),
              const SizedBox(height: 8),
              TextFormField(
                controller: namaController,
                focusNode: namaFocus,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lengkap tidak boleh kosong';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(emailFocus);
                },
              ),
              const SizedBox(height: 18),

              const Text('Email'),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                focusNode: emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Masukkan email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Email harus mengandung @';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(passwordFocus);
                },
              ),
              const SizedBox(height: 18),

              const Text('Password'),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                focusNode: passwordFocus,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'Minimal 6 karakter',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  daftar();
                },
              ),
              const SizedBox(height: 18),

              const Text(
                'Jenis Kelamin',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              RadioListTile<String>(
                title: const Text('Laki-laki'),
                value: 'Laki-laki',
                groupValue: jenisKelamin,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() {
                    jenisKelamin = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Perempuan'),
                value: 'Perempuan',
                groupValue: jenisKelamin,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() {
                    jenisKelamin = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              const Text('Program Studi'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: programStudi,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                  hintText: 'Pilih program studi',
                ),
                items: daftarProdi.map((prodi) {
                  return DropdownMenuItem<String>(
                    value: prodi,
                    child: Text(prodi),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    programStudi = value;
                  });
                },
              ),
              const SizedBox(height: 12),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Saya setuju dengan Syarat & Ketentuan'),
                value: setuju,
                onChanged: (value) {
                  setState(() {
                    setuju = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: daftar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

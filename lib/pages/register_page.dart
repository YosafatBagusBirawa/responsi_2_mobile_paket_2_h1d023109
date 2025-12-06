import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  bool loading = false;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(()=>loading=true);
    final res = await ApiService.post('/registrasi', {
      'nama': namaC.text.trim(),
      'email': emailC.text.trim(),
      'password': passC.text.trim(),
    });
    setState(()=>loading=false);

    if (res['status'] == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil, silakan login')));
      Navigator.pop(context);
    } else {
      final msg = res['data'] ?? 'Registrasi gagal';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Yosa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key:_formKey,
          child: ListView(
            children: [
              TextFormField(controller: namaC, decoration: const InputDecoration(labelText: 'Nama'), validator: (v)=> v==null||v.isEmpty ? 'Wajib diisi' : null),
              TextFormField(controller: emailC, decoration: const InputDecoration(labelText: 'Email'), validator: (v)=> v==null||v.isEmpty ? 'Wajib diisi' : null),
              TextFormField(controller: passC, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: (v)=> v==null||v.isEmpty ? 'Wajib diisi' : null),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: loading?null:submit, child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Registrasi')),
            ],
          ),
        ),
      ),
    );
  }
}

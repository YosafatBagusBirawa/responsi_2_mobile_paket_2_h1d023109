import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'register_page.dart';
import 'inventaris_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  bool loading = false;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final res = await ApiService.post('/login', {
      'email': emailC.text.trim(),
      'password': passC.text.trim(),
    });
    setState(() => loading = false);

    if (res['status'] == true) {
      final data = res['data'] as Map<String, dynamic>;
      final token = data['token'] ?? '';
      if (token != '') await ApiService.storeToken(token);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const InventarisListPage()));
    } else {
      final msg = res['data'] ?? 'Login gagal';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Yosa cihuy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key:_formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(controller: emailC, decoration: const InputDecoration(labelText: 'Email'), validator: (v)=> v==null||v.isEmpty ? 'Wajib diisi' : null),
              TextFormField(controller: passC, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: (v)=> v==null||v.isEmpty ? 'Wajib diisi' : null),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading ? null : submit,
                child: loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Login'),
              ),
              TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())), child: const Text('Belum punya akun? Registrasi'))
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/inventaris.dart';
import '../services/api_service.dart';

class InventarisFormPage extends StatefulWidget {
  final Inventaris? item;
  const InventarisFormPage({this.item, super.key});
  @override
  State<InventarisFormPage> createState() => _InventarisFormPageState();
}

class _InventarisFormPageState extends State<InventarisFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaC, hargaC, jumlahC, masukC, kadaluwarsaC;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final it = widget.item;
    namaC = TextEditingController(text: it?.nama ?? '');
    hargaC = TextEditingController(text: it?.harga.toString() ?? '');
    jumlahC = TextEditingController(text: it?.jumlah.toString() ?? '');
    masukC = TextEditingController(text: it?.tanggalMasuk ?? '');
    kadaluwarsaC = TextEditingController(text: it?.tanggalKedaluwarsa ?? '');
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(()=>saving=true);
    final body = {
      'nama': namaC.text.trim(),
      'harga': int.parse(hargaC.text.trim()),
      'jumlah': int.parse(jumlahC.text.trim()),
      'tanggal_masuk': masukC.text.trim(),
      'tanggal_kedaluwarsa': kadaluwarsaC.text.trim(),
    };

    if (widget.item == null) {
      final res = await ApiService.post('/inventaris', body);
      if (res['status'] == true) {
        if (!mounted) return;
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['data'].toString())));
      }
    } else {
      final res = await ApiService.put('/inventaris/${widget.item!.id}', body);
      if (res['status'] == true) {
        if (!mounted) return;
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['data'].toString())));
      }
    }
    setState(()=>saving=false);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Ubah Inventaris Yosa' : 'Tambah Inventaris Yosa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: namaC, decoration: const InputDecoration(labelText: 'Nama'), validator: (v)=> v==null||v.isEmpty ? 'Wajib diisi' : null),
              TextFormField(controller: hargaC, decoration: const InputDecoration(labelText: 'Harga'), keyboardType: TextInputType.number, validator: (v)=> v==null||v.isEmpty ? 'Wajib diisi' : null),
              TextFormField(controller: jumlahC, decoration: const InputDecoration(labelText: 'Jumlah'), keyboardType: TextInputType.number, validator: (v)=> v==null||v.isEmpty ? 'Wajib diisi' : null),
              TextFormField(controller: masukC, decoration: const InputDecoration(labelText: 'Tanggal Masuk (YYYY-MM-DD)'), validator: (v)=> v==null||v.isEmpty ? 'Wajib diisi' : null),
              TextFormField(controller: kadaluwarsaC, decoration: const InputDecoration(labelText: 'Tanggal Kedaluwarsa (YYYY-MM-DD)'), validator: (v)=> v==null||v.isEmpty ? 'Wajib diisi' : null),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: saving ? null : submit,
                child: saving ? const CircularProgressIndicator(color: Colors.white) : Text(isEdit ? 'Simpan Perubahan' : 'Tambah'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

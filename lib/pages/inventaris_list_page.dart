import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/inventaris.dart';
import 'inventaris_form_page.dart';
import 'login_page.dart';

class InventarisListPage extends StatefulWidget {
  const InventarisListPage({super.key});
  @override
  State<InventarisListPage> createState() => _InventarisListPageState();
}

class _InventarisListPageState extends State<InventarisListPage> {
  List<Inventaris> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    setState(() => loading = true);
    final res = await ApiService.get('/inventaris');
    if (res['status'] == true) {
      final data = res['data'] as List;
      items = data.map((e) => Inventaris.fromJson(e)).toList();
    } else {
      items = [];
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['data'].toString())));
    }
    setState(() => loading = false);
  }

  Future<void> deleteItem(int id) async {
    final res = await ApiService.delete('/inventaris/$id');
    if (res['status'] == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil dihapus')));
      fetchItems();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['data'].toString())));
    }
  }

  Future<void> logout() async {
    await ApiService.clearToken();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Yosa'),
        actions: [
          IconButton(onPressed: () => logout(), icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const InventarisFormPage()));
          if (res == true) fetchItems();
        },
        child: const Icon(Icons.add),
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) :
      RefreshIndicator(
        onRefresh: fetchItems,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final it = items[index];
            return Card(
              child: ListTile(
                title: Text(it.nama),
                subtitle: Text('Harga: ${it.harga} | Jumlah: ${it.jumlah}\nMasuk: ${it.tanggalMasuk} | Kadaluarsa: ${it.tanggalKedaluwarsa}'),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'edit') {
                      final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => InventarisFormPage(item: it)));
                      if (updated == true) fetchItems();
                    } else if (v == 'delete') {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (c)=> AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: const Text('Hapus item ini?'),
                          actions: [
                            TextButton(onPressed: ()=> Navigator.pop(c,false), child: const Text('Batal')),
                            TextButton(onPressed: ()=> Navigator.pop(c,true), child: const Text('Hapus')),
                          ],
                        )
                      );
                      if (ok == true) deleteItem(it.id!);
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                  ],
                ),
              ),
            );
          }
        ),
      )
    );
  }
}

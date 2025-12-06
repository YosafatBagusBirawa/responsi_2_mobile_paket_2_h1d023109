class Inventaris {
  int? id;
  String nama;
  int harga;
  int jumlah;
  String tanggalMasuk;
  String tanggalKedaluwarsa;

  Inventaris({
    this.id,
    required this.nama,
    required this.harga,
    required this.jumlah,
    required this.tanggalMasuk,
    required this.tanggalKedaluwarsa,
  });

  factory Inventaris.fromJson(Map<String, dynamic> json) {
    return Inventaris(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      nama: json['nama'] ?? '',
      harga: json['harga'] is int ? json['harga'] : int.tryParse('${json['harga']}') ?? 0,
      jumlah: json['jumlah'] is int ? json['jumlah'] : int.tryParse('${json['jumlah']}') ?? 0,
      tanggalMasuk: json['tanggal_masuk'] ?? json['tanggalMasuk'] ?? '',
      tanggalKedaluwarsa: json['tanggal_kedaluwarsa'] ?? json['tanggalKedaluwarsa'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama': nama,
      'harga': harga,
      'jumlah': jumlah,
      'tanggal_masuk': tanggalMasuk,
      'tanggal_kedaluwarsa': tanggalKedaluwarsa,
    };
  }
}

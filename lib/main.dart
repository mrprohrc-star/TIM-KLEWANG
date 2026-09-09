import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const HondaSalesApp());
}

class HondaSalesApp extends StatelessWidget {
  const HondaSalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Honda Sales Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE60000)),
        useMaterial3: true,
      ),
      home: const SimulasiKreditPage(),
    );
  }
}

class MotorHonda {
  final String nama;
  final int hargaOtr;
  MotorHonda({required this.nama, required this.hargaOtr});
}

final List<MotorHonda> listMotor = [
  MotorHonda(nama: 'BeAT CBS', hargaOtr: 18430000),
  MotorHonda(nama: 'BeAT Deluxe', hargaOtr: 19300000),
  MotorHonda(nama: 'Scoopy Prestige / Stylish', hargaOtr: 23230000),
  MotorHonda(nama: 'Genio CBS-ISS', hargaOtr: 19575000),
  MotorHonda(nama: 'Vario 125 CBS-ISS', hargaOtr: 24450000),
  MotorHonda(nama: 'Vario 160 CBS', hargaOtr: 27350000),
  MotorHonda(nama: 'PCX 160 CBS', hargaOtr: 33300000),
  MotorHonda(nama: 'ADV 160 CBS', hargaOtr: 36200000),
  MotorHonda(nama: 'Stylo 160 CBS', hargaOtr: 28045000),
  MotorHonda(nama: 'CB150R Streetfire', hargaOtr: 31100000),
];

class SimulasiKreditPage extends StatefulWidget {
  const SimulasiKreditPage({super.key});

  @override
  State<SimulasiKreditPage> createState() => _SimulasiKreditPageState();
}

class _SimulasiKreditPageState extends State<SimulasiKreditPage> {
  MotorHonda _selectedMotor = listMotor[0];
  final _dpController = TextEditingController(text: '2000000');
  final _diskonDpController = TextEditingController(text: '500000');
  final _namaKonsumenController = TextEditingController();
  final _waKonsumenController = TextEditingController();

  int _selectedTenor = 35;
  final List<int> _listTenor = [11, 17, 23, 29, 35];
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  int get dpBayar {
    int dpGross = int.tryParse(_dpController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int diskon = int.tryParse(_diskonDpController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int net = dpGross - diskon;
    return net > 0 ? net : 0;
  }

  int get angsuranBulanan {
    int dpGross = int.tryParse(_dpController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int pokokHutang = _selectedMotor.hargaOtr - dpGross;
    if (pokokHutang <= 0) return 0;

    double bungaPerBulan = 0.02; // Bunga leasing ~2% flat
    double totalBunga = pokokHutang * bungaPerBulan * _selectedTenor;
    double totalBayar = pokokHutang + totalBunga;

    return (totalBayar / _selectedTenor).round();
  }

  void _kirimKeWhatsApp() async {
    String noHp = _waKonsumenController.text.trim();
    if (noHp.startsWith('0')) {
      noHp = '62${noHp.substring(1)}';
    }

    String nama = _namaKonsumenController.text.isNotEmpty ? _namaKonsumenController.text : 'Konsumen';
    String pesan = '''
*PENAWARAN RESMI MOTOR HONDA* 🛵
Halo $nama, berikut rincian simulasi kreditnya:

🏍️ *Unit:* ${_selectedMotor.nama}
🏷️ *Harga OTR:* ${currencyFormat.format(_selectedMotor.hargaOtr)}
💰 *DP Normal:* ${currencyFormat.format(int.tryParse(_dpController.text) ?? 0)}
🎁 *Diskon DP:* ${currencyFormat.format(int.tryParse(_diskonDpController.text) ?? 0)}
👉 *DP Bayar Bersih:* *${currencyFormat.format(dpBayar)}*

⏱️ *Tenor:* $_selectedTenor Bulan
💵 *Angsuran:* *${currencyFormat.format(angsuranBulanan)} / bln*

_Syarat Pengajuan: KTP & KK saja. Proses cepat & dibantu sampai ACC!_
Info & Pemesanan langsung hubungi kami ya. Terima kasih!
''';

    final Uri url = Uri.parse("https://wa.me/$noHp?text=${Uri.encodeComponent(pesan)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Honda Sales Assistant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFE60000),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Unit Motor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MotorHonda>(
                  isExpanded: true,
                  value: _selectedMotor,
                  items: listMotor.map((motor) {
                    return DropdownMenuItem(
                      value: motor,
                      child: Text('${motor.nama} - ${currencyFormat.format(motor.hargaOtr)}'),
                    );
                  }).toList>,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedMotor = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'DP Kotor (Rp)', border: OutlineInputBorder()),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _diskonDpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Diskon DP (Rp)', border: OutlineInputBorder()),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Tenor (Bulan)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _listTenor.map((tenor) {
                final isSelected = _selectedTenor == tenor;
                return ChoiceChip(
                  label: Text('$tenor Bln'),
                  selected: isSelected,
                  selectedColor: const Color(0xFFE60000),
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  onSelected: (val) {
                    if (val) setState(() => _selectedTenor = tenor);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE60000), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('DP Bayar Bersih:', style: TextStyle(fontSize: 15)),
                        Text(currencyFormat.format(dpBayar), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Angsuran Per Bulan:', style: TextStyle(fontSize: 15)),
                        Text(currencyFormat.format(angsuranBulanan), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE60000))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Kirim Penawaran ke Konsumen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: _namaKonsumenController,
              decoration: const InputDecoration(labelText: 'Nama Calon Konsumen', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _waKonsumenController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'No. WhatsApp (08xxx)', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white),
                onPressed: _kirimKeWhatsApp,
                icon: const Icon(Icons.send),
                label: const Text('Kirim Rincian via WhatsApp', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

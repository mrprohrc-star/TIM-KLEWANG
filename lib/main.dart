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

class MotorBrosur {
  final String nama;
  final int hargaOtr;
  final int defaultDpKotor;
  final int defaultDiskon;
  final Map<int, Map<int, int>> skema; // dpGross -> { tenor: angsuran }

  MotorBrosur({
    required this.nama,
    required this.hargaOtr,
    required this.defaultDpKotor,
    required this.defaultDiskon,
    required this.skema,
  });
}

final List<MotorBrosur> daftarBrosur = [
  MotorBrosur(
    nama: 'BeAT Sporty Deluxe CBS ISS Plus',
    hargaOtr: 19807500,
    defaultDpKotor: 2000000,
    defaultDiskon: 300000,
    skema: {
      2000000: {12: 2105000, 18: 1527000, 23: 1262000, 29: 1046000, 35: 950000, 41: 839000, 47: 784000},
      2500000: {12: 2051000, 18: 1489000, 23: 1231000, 29: 1020000, 35: 927000, 41: 819000, 47: 765000},
      3000000: {12: 1997000, 18: 1451000, 23: 1200000, 29: 995000, 35: 904000, 41: 799000, 47: 746000},
    },
  ),
  MotorBrosur(
    nama: 'BeAT Street Plus',
    hargaOtr: 19596500,
    defaultDpKotor: 1800000,
    defaultDiskon: 100000,
    skema: {
      1800000: {12: 2111000, 18: 1532000, 23: 1255000, 29: 1043000, 35: 932000, 41: 839000, 47: 784000},
      2500000: {12: 2035000, 18: 1479000, 23: 1212000, 29: 1007000, 35: 901000, 41: 811000, 47: 758000},
      3000000: {12: 1981000, 18: 1441000, 23: 1181000, 29: 982000, 35: 878000, 41: 791000, 47: 739000},
    },
  ),
  MotorBrosur(
    nama: 'Scoopy Fashion',
    hargaOtr: 22023000,
    defaultDpKotor: 2200000,
    defaultDiskon: 200000,
    skema: {
      2200000: {12: 2253000, 18: 1668000, 22: 1416000, 28: 1182000, 34: 1083000, 40: 1000000, 46: 941000},
      3000000: {12: 2169000, 18: 1608000, 22: 1366000, 28: 1140000, 34: 1045000, 40: 965000, 46: 908000},
    },
  ),
  MotorBrosur(
    nama: 'Scoopy Stylish Plus',
    hargaOtr: 23242000,
    defaultDpKotor: 2300000,
    defaultDiskon: 200000,
    skema: {
      2300000: {12: 2372000, 18: 1755000, 24: 1492000, 30: 1244000, 36: 1136000, 42: 1048000, 48: 987000},
      3000000: {12: 2299000, 18: 1702000, 24: 1448000, 30: 1208000, 36: 1103000, 42: 1018000, 48: 958000},
    },
  ),
  MotorBrosur(
    nama: 'Stylo 160 CBS',
    hargaOtr: 28004000,
    defaultDpKotor: 2300000,
    defaultDiskon: 0,
    skema: {
      2300000: {12: 2959000, 18: 2169000, 24: 1741000, 30: 1486000, 36: 1348000, 42: 1266000, 48: 1191000},
      3000000: {12: 2884000, 18: 2115000, 24: 1698000, 30: 1450000, 36: 1316000, 42: 1235000, 48: 1163000},
    },
  ),
  MotorBrosur(
    nama: 'Stylo 160 ABS',
    hargaOtr: 30123000,
    defaultDpKotor: 2500000,
    defaultDiskon: 0,
    skema: {
      2500000: {12: 3173000, 18: 2325000, 24: 1862000, 30: 1598000, 36: 1458000, 42: 1354000, 48: 1274000},
      3000000: {12: 3119000, 18: 2286000, 24: 1832000, 30: 1572000, 36: 1435000, 42: 1332000, 48: 1254000},
    },
  ),
  MotorBrosur(
    nama: 'Vario 160 EVO CBS Nitro',
    hargaOtr: 27048000,
    defaultDpKotor: 2500000,
    defaultDiskon: 200000,
    skema: {
      2500000: {12: 2856000, 18: 2059000, 23: 1760000, 29: 1424000, 35: 1307000, 41: 1225000, 47: 1154000},
      3000000: {12: 2802000, 18: 2021000, 23: 1728000, 29: 1398000, 35: 1283000, 41: 1203000, 47: 1133000},
    },
  ),
  MotorBrosur(
    nama: 'Vario 160 EVO CBS',
    hargaOtr: 26822000,
    defaultDpKotor: 2500000,
    defaultDiskon: 200000,
    skema: {
      2500000: {12: 2831000, 18: 2041000, 23: 1745000, 29: 1412000, 35: 1296000, 41: 1214000, 47: 1144000},
      3000000: {12: 2777000, 18: 2003000, 23: 1713000, 29: 1386000, 35: 1272000, 41: 1192000, 47: 1123000},
    },
  ),
  MotorBrosur(
    nama: 'Vario 160 EVO ABS',
    hargaOtr: 29024000,
    defaultDpKotor: 2600000,
    defaultDiskon: 200000,
    skema: {
      2600000: {12: 3065000, 18: 2212000, 23: 1866000, 29: 1518000, 35: 1400000, 41: 1294000, 47: 1218000},
      3000000: {12: 3022000, 18: 2181000, 23: 1840000, 29: 1497000, 35: 1382000, 41: 1277000, 47: 1201000},
    },
  ),
];

class SimulasiKreditPage extends StatefulWidget {
  const SimulasiKreditPage({super.key});

  @override
  State<SimulasiKreditPage> createState() => _SimulasiKreditPageState();
}

class _SimulasiKreditPageState extends State<SimulasiKreditPage> {
  late MotorBrosur _selectedMotor;
  late TextEditingController _dpController;
  late TextEditingController _diskonDpController;
  final TextEditingController _namaKonsumenController = TextEditingController();
  final TextEditingController _waKonsumenController = TextEditingController();

  int _selectedTenor = 35;
  final List<int> _listTenor = [12, 18, 23, 29, 35, 41, 47];
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _selectedMotor = daftarBrosur[0];
    _dpController = TextEditingController(text: _selectedMotor.defaultDpKotor.toString());
    _diskonDpController = TextEditingController(text: _selectedMotor.defaultDiskon.toString());
  }

  void _onMotorChanged(MotorBrosur motor) {
    setState(() {
      _selectedMotor = motor;
      _dpController.text = motor.defaultDpKotor.toString();
      _diskonDpController.text = motor.defaultDiskon.toString();
    });
  }

  int get dpBayar {
    int dpGross = int.tryParse(_dpController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int diskon = int.tryParse(_diskonDpController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    int net = dpGross - diskon;
    return net > 0 ? net : 0;
  }

  int get angsuranBulanan {
    int dpGross = int.tryParse(_dpController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    
    // Cek apakah ada di tabel brosur persis
    if (_selectedMotor.skema.containsKey(dpGross) && _selectedMotor.skema[dpGross]!.containsKey(_selectedTenor)) {
      return _selectedMotor.skema[dpGross]![_selectedTenor]!;
    }

    // Jika custom DP, gunakan interpolasi rate leasing brosur
    int pokokHutang = _selectedMotor.hargaOtr - dpGross;
    if (pokokHutang <= 0) return 0;
    double bungaPerBulan = 0.0175; // Rate leasing brosur Honda
    double totalBunga = pokokHutang * bungaPerBulan * _selectedTenor;
    double totalBayar = pokokHutang + totalBunga;
    return (totalBayar / _selectedTenor).round();
  }

  Future<void> _kirimKeWhatsApp() async {
    String noHp = _waKonsumenController.text.trim();
    if (noHp.startsWith('0')) {
      noHp = '62${noHp.substring(1)}';
    }

    String nama = _namaKonsumenController.text.isNotEmpty ? _namaKonsumenController.text : 'Konsumen';
    String pesan = '''
*PENAWARAN RESMI MOTOR HONDA* 🛵
Halo $nama, berikut rincian simulasi kredit brosur resminya:

🏍️ *Unit:* ${_selectedMotor.nama}
🏷️ *Harga OTR:* ${_currencyFormat.format(_selectedMotor.hargaOtr)}
💰 *DP Normal:* ${_currencyFormat.format(int.tryParse(_dpController.text) ?? 0)}
🎁 *Diskon DP:* ${_currencyFormat.format(int.tryParse(_diskonDpController.text) ?? 0)}
👉 *DP Bayar Bersih (Promo):* ${_currencyFormat.format(dpBayar)}

⏱️ *Tenor:* $_selectedTenor Bulan
💵 *Angsuran:* ${_currencyFormat.format(angsuranBulanan)} / bln

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
            const Text('Pilih Unit Motor (Sesuai Brosur)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MotorBrosur>(
                  isExpanded: true,
                  value: _selectedMotor,
                  items: daftarBrosur.map((motor) {
                    return DropdownMenuItem(
                      value: motor,
                      child: Text('${motor.nama} - ${_currencyFormat.format(motor.hargaOtr)}', style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) _onMotorChanged(val);
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
                    decoration: const InputDecoration(labelText: 'DP Normal (Rp)', border: OutlineInputBorder()),
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
            const Text('Pilihan Tenor (Bulan)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                        const Text('DP Bayar Bersih (Promo):', style: TextStyle(fontSize: 15)),
                        Text(_currencyFormat.format(dpBayar), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Angsuran Per Bulan:', style: TextStyle(fontSize: 15)),
                        Text(_currencyFormat.format(angsuranBulanan), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE60000))),
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

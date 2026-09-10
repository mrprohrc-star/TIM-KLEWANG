import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const HondaSalesApp());
}

class HondaSalesApp extends StatelessWidget {
  const HondaSalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIM KLEWANG - Honda Sales',
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
  final String tipe;
  final int hargaOtr;
  final int defaultDpKotor;
  final int defaultDiskon;
  final Map<int, Map<int, int>> skema;

  MotorBrosur({
    required this.nama,
    required this.tipe,
    required this.hargaOtr,
    required this.defaultDpKotor,
    required this.defaultDiskon,
    required this.skema,
  });
}

final List<MotorBrosur> daftarBrosur = [
  MotorBrosur(
    nama: 'BeAT Sporty Deluxe CBS ISS Plus',
    tipe: 'Matic 110cc',
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
    tipe: 'Matic 110cc',
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
    tipe: 'Matic 110cc Retro',
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
    tipe: 'Matic 110cc Smartkey',
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
    tipe: 'Matic 160cc Modern Retro',
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
    tipe: 'Matic 160cc ABS',
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
    tipe: 'Matic 160cc Sporty',
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
    tipe: 'Matic 160cc Standard',
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
    tipe: 'Matic 160cc ABS',
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

  File? _ktpFile;
  File? _kkFile;
  bool _isProcessingOcr = false;

  final TextEditingController _namaPemohonController = TextEditingController();
  final TextEditingController _nikKtpController = TextEditingController();
  final TextEditingController _nikKkController = TextEditingController();
  final TextEditingController _ttlController = TextEditingController();
  final TextEditingController _ibuKandungController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _rumahController = TextEditingController();
  final TextEditingController _tlpnController = TextEditingController();
  final TextEditingController _warnaController = TextEditingController();
  final TextEditingController _namaStnkController = TextEditingController();
  final TextEditingController _sumberDataController = TextEditingController(text: 'PAMERAN GRIYA');
  final TextEditingController _hasilController = TextEditingController();

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
    if (_selectedMotor.skema.containsKey(dpGross) && _selectedMotor.skema[dpGross]!.containsKey(_selectedTenor)) {
      return _selectedMotor.skema[dpGross]![_selectedTenor]!;
    }
    int pokokHutang = _selectedMotor.hargaOtr - dpGross;
    if (pokokHutang <= 0) return 0;
    double bungaPerBulan = 0.0175;
    double totalBunga = pokokHutang * bungaPerBulan * _selectedTenor;
    double totalBayar = pokokHutang + totalBunga;
    return (totalBayar / _selectedTenor).round();
  }

  Future<void> _pilihFoto(bool isKtp) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 95);
    if (picked != null) {
      setState(() {
        if (isKtp) {
          _ktpFile = File(picked.path);
        } else {
          _kkFile = File(picked.path);
        }
      });
    }
  }

  String _cleanOcrValue(String text, List<String> stopWords) {
    String res = text.replaceAll(RegExp(r'[:=]'), ' ').trim();
    for (var word in stopWords) {
      res = res.replaceAll(RegExp(word, caseSensitive: false), ' ');
    }
    return res.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<void> _prosesOcr() async {
    if (_ktpFile == null && _kkFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih foto KTP atau KK terlebih dahulu!'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isProcessingOcr = true);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      if (_ktpFile != null) {
        final inputImage = InputImage.fromFile(_ktpFile!);
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        final List<String> allLines = [];

        for (var block in recognizedText.blocks) {
          for (var line in block.lines) {
            String txt = line.text.trim();
            if (txt.isNotEmpty) allLines.add(txt);
          }
        }

        List<String> alamatParts = [];
        bool capturingAlamat = false;

        for (int i = 0; i < allLines.length; i++) {
          String raw = allLines[i];
          String lower = raw.toLowerCase();

          // 1. NIK
          if (_nikKtpController.text.isEmpty) {
            final nikMatch = RegExp(r'\b\d{16}\b').firstMatch(raw.replaceAll(RegExp(r'[^0-9]'), ''));
            if (nikMatch != null) {
              _nikKtpController.text = nikMatch.group(0)!;
            }
          }

          // 2. Nama Pemohon
          if (lower.contains('nama') && !lower.contains('agama') && !lower.contains('status')) {
            String val = _cleanOcrValue(raw, ['nama', 'provinsi', 'republik', 'indonesia']);
            if (val.isEmpty && i + 1 < allLines.length && !allLines[i + 1].toLowerCase().contains('tempat') && !allLines[i + 1].toLowerCase().contains('nik')) {
              val = allLines[i + 1].trim();
            }
            if (val.isNotEmpty && !val.toLowerCase().contains('tempat') && !val.toLowerCase().contains('lahir')) {
              _namaPemohonController.text = val;
              if (_namaStnkController.text.isEmpty) _namaStnkController.text = val;
            }
          }

          // 3. TTL
          if (lower.contains('tempat') || lower.contains('tgl lahir') || lower.contains('lahir')) {
            String val = _cleanOcrValue(raw, ['tempat', 'tgl', 'lahir', 'tgllahir']);
            if (val.isEmpty && i + 1 < allLines.length && !allLines[i + 1].toLowerCase().contains('jenis') && !allLines[i + 1].toLowerCase().contains('alamat')) {
              val = allLines[i + 1].trim();
            }
            if (val.isNotEmpty && !val.toLowerCase().contains('jenis') && !val.toLowerCase().contains('kelamin')) {
              _ttlController.text = val;
            }
          }

          // 4. Pekerjaan
          if (lower.contains('pekerjaan')) {
            String val = _cleanOcrValue(raw, ['pekerjaan']);
            if (val.isEmpty && i + 1 < allLines.length) val = allLines[i + 1].trim();
            if (val.isNotEmpty && !val.toLowerCase().contains('kewarganegaraan')) {
              _pekerjaanController.text = val;
            }
          }

          // 5. Alamat Lengkap
          if (lower.contains('alamat')) {
            capturingAlamat = true;
            String val = _cleanOcrValue(raw, ['alamat']);
            if (val.isNotEmpty) alamatParts.add(val);
          } else if (capturingAlamat) {
            if (lower.contains('rt/rw') || lower.contains('rt') || lower.contains('rw') || lower.contains('kel') || lower.contains('desa') || lower.contains('kecamatan')) {
              alamatParts.add(_cleanOcrValue(raw, []));
            } else if (lower.contains('agama') || lower.contains('status') || lower.contains('pekerjaan') || lower.contains('kawin')) {
              capturingAlamat = false;
            }
          }
        }

        if (alamatParts.isNotEmpty) {
          _alamatController.text = alamatParts.join(', ');
        }
      }

      // OCR Kartu Keluarga
      if (_kkFile != null) {
        final inputImage = InputImage.fromFile(_kkFile!);
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        final List<String> kkLines = [];

        for (var block in recognizedText.blocks) {
          for (var line in block.lines) {
            kkLines.add(line.text.trim());
          }
        }

        for (String line in kkLines) {
          final nikMatch = RegExp(r'\b\d{16}\b').firstMatch(line.replaceAll(RegExp(r'[^0-9]'), ''));
          if (nikMatch != null && _nikKkController.text.isEmpty) {
            _nikKkController.text = nikMatch.group(0)!;
            break;
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Data KTP & KK berhasil dipindai rapi!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membaca OCR: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      await textRecognizer.close();
      if (mounted) setState(() => _isProcessingOcr = false);
    }
  }

  void _bersihkanDokumen() {
    setState(() {
      _ktpFile = null;
      _kkFile = null;
    });
  }

  void _salinFormatTimKlewang(BuildContext context) {
    String teks = '''*TIM KLEWANG*

```Nama Pemohon : ${_namaPemohonController.text}
NIK KTP : ${_nikKtpController.text}
NIK KK  : ${_nikKkController.text}
TTL: ${_ttlController.text}
Ibu Kandung : ${_ibuKandungController.text}
Alamat : ${_alamatController.text}
Pekerjaan : ${_pekerjaanController.text}
Rumah  : ${_rumahController.text}
Tlpn: ${_tlpnController.text}
__________________________
Motor : ${_selectedMotor.nama}
Tipe  : ${_selectedMotor.tipe}
Warna : ${_warnaController.text}
OTR   : ${_currencyFormat.format(_selectedMotor.hargaOtr)}
DP    : ${_currencyFormat.format(dpBayar)}
ANGS  : ${_currencyFormat.format(angsuranBulanan)}
TENOR : $_selectedTenor
___________________________________
Nama Stnk : ${_namaStnkController.text}
___________________________________
SUMBER DATA : ``` *${_sumberDataController.text}* ```
___________________________________
HASIL : ${_hasilController.text}```''';

    Clipboard.setData(ClipboardData(text: teks));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Format TIM KLEWANG berhasil disalin!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TIM KLEWANG - OCR & Sales', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFE60000),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Dokumen Konsumen (OCR KTP & KK)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Unggah foto KTP dan KK untuk auto-fill data secara presisi.', style: TextStyle(color: Colors.black54, fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pilihFoto(true),
                          icon: const Icon(Icons.badge_outlined),
                          label: const Text('Foto KTP'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pilihFoto(false),
                          icon: const Icon(Icons.family_restroom_outlined),
                          label: const Text('Foto KK'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: _ktpFile != null
                              ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_ktpFile!, fit: BoxFit.cover))
                              : const Center(child: Text('Preview KTP', style: TextStyle(color: Colors.grey))),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: _kkFile != null
                              ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_kkFile!, fit: BoxFit.cover))
                              : const Center(child: Text('Preview KK', style: TextStyle(color: Colors.grey))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE60000),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _isProcessingOcr ? null : _prosesOcr,
                          icon: _isProcessingOcr
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.document_scanner),
                          label: Text(_isProcessingOcr ? 'Memproses...' : 'Baca Dokumen (OCR)'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _bersihkanDokumen,
                        child: const Text('Bersihkan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('2. Pilih Unit Motor (Brosur)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            const SizedBox(height: 14),
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
            const SizedBox(height: 14),
            const Text('Pilihan Tenor (Bulan)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
            const SizedBox(height: 14),
            Card(
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE60000), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('DP Bersih (Promo):', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        Text(_currencyFormat.format(dpBayar), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Angsuran Per Bulan:', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        Text(_currencyFormat.format(angsuranBulanan), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE60000))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 2),
            const SizedBox(height: 8),
            const Text('3. Format Data Konsumen (TIM KLEWANG)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 12),
            TextField(controller: _namaPemohonController, decoration: const InputDecoration(labelText: 'Nama Pemohon', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _nikKtpController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'NIK KTP', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _nikKkController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'NIK KK', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _ttlController, decoration: const InputDecoration(labelText: 'TTL (Tempat, Tanggal Lahir)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _ibuKandungController, decoration: const InputDecoration(labelText: 'Nama Ibu Kandung (Isi Manual / dari KK)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _alamatController, maxLines: 2, decoration: const InputDecoration(labelText: 'Alamat Lengkap', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField(controller: _pekerjaanController, decoration: const InputDecoration(labelText: 'Pekerjaan', border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                Expanded(child: TextField(controller: _rumahController, decoration: const InputDecoration(labelText: 'Status Rumah', border: OutlineInputBorder()))),
              ],
            ),
            const SizedBox(height: 10),
            TextField(controller: _tlpnController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'No. Telepon / WA', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _warnaController, decoration: const InputDecoration(labelText: 'Warna Motor Pilihan', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _namaStnkController, decoration: const InputDecoration(labelText: 'Nama STNK', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _sumberDataController, decoration: const InputDecoration(labelText: 'Sumber Data', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _hasilController, decoration: const InputDecoration(labelText: 'Hasil (Status ACC / Catatan)', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE60000),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _salinFormatTimKlewang(context),
                icon: const Icon(Icons.copy_all),
                label: const Text('Salin Format TIM KLEWANG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

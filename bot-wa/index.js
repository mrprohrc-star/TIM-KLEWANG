const { default: makeWASocket, useMultiFileAuthState, DisconnectReason, delay } = require('@whiskeysockets/baileys');
const pino = require('pino');
const readline = require('readline');

const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
const question = (text) => new Promise((resolve) => rl.question(text, resolve));

const dataMotor = {
  beat: { nama: 'BeAT CBS', otr: 'Rp 18.430.000', dp: 'Rp 1.500.000', angsuran: 'Rp 890.000 x 35 bln' },
  scoopy: { nama: 'Scoopy Prestige', otr: 'Rp 23.230.000', dp: 'Rp 2.000.000', angsuran: 'Rp 1.050.000 x 35 bln' },
  vario: { nama: 'Vario 125 CBS', otr: 'Rp 24.450.000', dp: 'Rp 2.200.000', angsuran: 'Rp 1.120.000 x 35 bln' },
  pcx: { nama: 'PCX 160 CBS', otr: 'Rp 33.300.000', dp: 'Rp 3.000.000', angsuran: 'Rp 1.480.000 x 35 bln' },
  adv: { nama: 'ADV 160 CBS', otr: 'Rp 36.200.000', dp: 'Rp 3.500.000', angsuran: 'Rp 1.590.000 x 35 bln' }
};

async function startBot() {
  const { state, saveCreds } = await useMultiFileAuthState('auth_session');
  
  const sock = makeWASocket({
    logger: pino({ level: 'silent' }),
    auth: state,
    printQRInTerminal: false,
    browser: ['Ubuntu', 'Chrome', '20.0.04']
  });

  if (!sock.authState.creds.registered) {
    const phoneNumber = await question('Masukkan nomor WA bot kamu (contoh: 628123456789): ');
    await delay(3000); // Beri jeda 3 detik agar socket siap
    try {
      const code = await sock.requestPairingCode(phoneNumber.trim().replace(/[^0-9]/g, ''));
      console.log(`\n👉 KODE PAIRING WHATSAPP: \x1b[32m${code}\x1b[0m\n`);
    } catch (err) {
      console.error('Gagal mengambil kode pairing, coba jalankan ulang:', err.message);
    }
  }

  sock.ev.on('creds.update', saveCreds);

  sock.ev.on('connection.update', (update) => {
    const { connection, lastDisconnect } = update;
    if (connection === 'close') {
      const shouldReconnect = lastDisconnect?.error?.output?.statusCode !== DisconnectReason.loggedOut;
      if (shouldReconnect) startBot();
    } else if (connection === 'open') {
      console.log('✅ Bot WhatsApp Honda Sales Berhasil Terhubung!');
    }
  });

  sock.ev.on('messages.upsert', async ({ messages, type }) => {
    if (type !== 'notify') return;
    const msg = messages[0];
    if (!msg.message || msg.key.fromMe) return;

    const from = msg.key.remoteJid;
    const body = msg.message.conversation || msg.message.extendedTextMessage?.text || '';
    const text = body.toLowerCase().trim();

    if (text === 'menu' || text === 'halo' || text === 'p' || text === 'info') {
      const menuText = `Halo! Selamat datang di Layanan Otomatis *Honda Sales*. 🛵✨

Ketik salah satu perintah di bawah:
📌 *!daftar* - Lihat daftar tipe motor
📌 *!beat* - Simulasi kredit BeAT
📌 *!scoopy* - Simulasi kredit Scoopy
📌 *!vario* - Simulasi kredit Vario 125
📌 *!pcx* - Simulasi kredit PCX 160
📌 *!adv* - Simulasi kredit ADV 160
📌 *!syarat* - Syarat pengajuan kredit
📌 *!daftarform* - Format kirim data konsumen`;
      await sock.sendMessage(from, { text: menuText }, { quoted: msg });
    } else if (text.startsWith('!')) {
      const cmd = text.slice(1);
      if (dataMotor[cmd]) {
        const m = dataMotor[cmd];
        const detail = `🏍️ *SIMULASI RESMI HONDA*
Unit: *${m.nama}*
OTR: *${m.otr}*
Estimasi DP: *${m.dp}*
Estimasi Angsuran: *${m.angsuran}*

_Syarat cukup KTP & KK, dibantu sampai ACC!_
Ketik *!daftarform* untuk pengajuan.`;
        await sock.sendMessage(from, { text: detail }, { quoted: msg });
      } else if (cmd === 'syarat') {
        const syarat = `📋 *SYARAT PENGAJUAN KREDIT:*
1. KTP Pemohon & Penjamin
2. Kartu Keluarga (KK)
3. Rekening Listrik / Bukti Domisili`;
        await sock.sendMessage(from, { text: syarat }, { quoted: msg });
      } else if (cmd === 'daftarform') {
        const form = `📝 *FORMAT PENGAJUAN DATA KONSUMEN:*
Silakan salin dan lengkapi:

- Nama Lengkap:
- Alamat KTP:
- No. WhatsApp:
- Unit Pilihan:
- Rencana DP:
- Pilihan Tenor (bln):`;
        await sock.sendMessage(from, { text: form }, { quoted: msg });
      }
    }
  });
}

startBot();

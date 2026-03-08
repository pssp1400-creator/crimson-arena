import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../services/firebase_service.dart';
import '../services/telegram_service.dart';

// ══════════════════════════════════════════════════════════════
//  RECEIPT SCREEN
// ══════════════════════════════════════════════════════════════
class ReceiptScreen extends StatelessWidget {
  final String regKey, ign, team, matchType, skillMode, targetArea, fee, winPrize;
  const ReceiptScreen({super.key, required this.regKey, required this.ign, required this.team, required this.matchType, required this.skillMode, required this.targetArea, required this.fee, required this.winPrize});

  String get _receiptId => 'CA-${regKey.substring(0,6).toUpperCase()}';

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GridBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(border: Border.all(color: CrimsonColors.border), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.arrow_back_ios_new, size: 16, color: CrimsonColors.blueGlow))),
                const SizedBox(width: 16),
                Text('RECEIPT', style: CrimsonText.hud(size: 16, weight: FontWeight.w700)),
              ]),
            ),
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                // Receipt Card
                GlassCard(
                  borderRadius: 20,
                  borderColor: CrimsonColors.purple.withOpacity(0.4),
                  child: Column(children: [
                    // Top accent
                    Container(height: 2, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, CrimsonColors.crimson, CrimsonColors.purple, CrimsonColors.blue, Colors.transparent]))),
                    const SizedBox(height: 20),
                    Text('CRIMSON ARENA', style: CrimsonText.hud(size: 18, weight: FontWeight.w900, color: Colors.white)),
                    Text('OFFICIAL RECEIPT', style: CrimsonText.mono(size: 10, color: CrimsonColors.muted)),
                    const SizedBox(height: 8),
                    NeonBadge(label: _receiptId, color: CrimsonColors.cyan),
                    const SizedBox(height: 20),
                    const GlowDivider(),
                    ...[
                      ['IGN',         ign],
                      if (team.isNotEmpty) ['TEAM', team],
                      ['MATCH TYPE',  matchType.toUpperCase()],
                      ['SKILL MODE',  skillMode.toUpperCase()],
                      ['TARGET AREA', targetArea.toUpperCase()],
                      ['ENTRY FEE',   fee],
                      ['WIN PRIZE',   winPrize],
                      ['STATUS',      'PENDING PAYMENT'],
                    ].map((row) => _ReceiptRow(label: row[0], value: row[1])),
                    const SizedBox(height: 12),
                  ]),
                ),

                const SizedBox(height: 20),

                // Copy button
                NeonSecondaryButton(
                  label: '📋  COPY RECEIPT',
                  onPressed: () {
                    final text = 'CRIMSON ARENA RECEIPT\n$_receiptId\nIGN: $ign\nMatch: $matchType | $skillMode\nFee: $fee | Win: $winPrize\nStatus: Pending';
                    Clipboard.setData(ClipboardData(text: text));
                    showCrimsonToast(context, '✅ Receipt copied!');
                  },
                ),

                const SizedBox(height: 16),

                NeonButton(
                  label: 'PROCEED TO PAYMENT →',
                  width: double.infinity,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(regKey: regKey, fee: fee, ign: ign, matchType: matchType, skillMode: skillMode, targetArea: targetArea, winPrize: winPrize, team: team))),
                ),
                const SizedBox(height: 40),
              ]),
            )),
          ],
        ),
      ),
    ),
  );
}

class _ReceiptRow extends StatelessWidget {
  final String label, value;
  const _ReceiptRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: CrimsonText.mono(size: 11, color: CrimsonColors.muted)),
        Text(value, style: CrimsonText.hud(size: 12, weight: FontWeight.w600, color: CrimsonColors.text)),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════
//  PAYMENT SCREEN
// ══════════════════════════════════════════════════════════════
class PaymentScreen extends StatelessWidget {
  final String regKey, fee, ign, matchType, skillMode, targetArea, winPrize, team;
  const PaymentScreen({super.key, required this.regKey, required this.fee, required this.ign, required this.matchType, required this.skillMode, required this.targetArea, required this.winPrize, required this.team});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GridBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(border: Border.all(color: CrimsonColors.border), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.arrow_back_ios_new, size: 16, color: CrimsonColors.blueGlow))),
                const SizedBox(width: 16),
                Text('PAYMENT', style: CrimsonText.hud(size: 16, weight: FontWeight.w700)),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  GlassCard(
                    borderRadius: 20,
                    child: Column(children: [
                      Text('SCAN & PAY', style: CrimsonText.hud(size: 16, weight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Pay $fee to complete registration', style: CrimsonText.body(size: 13, color: CrimsonColors.muted)),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset('assets/qr.png', width: 220, height: 220, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: CrimsonColors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: CrimsonColors.green.withOpacity(0.3))),
                        child: Text('Amount: $fee', style: CrimsonText.hud(size: 20, weight: FontWeight.w700, color: CrimsonColors.greenL), textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 12),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    borderColor: CrimsonColors.cyan.withOpacity(0.3),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('📌 IMPORTANT STEPS', style: CrimsonText.mono(size: 11, color: CrimsonColors.cyan)),
                      const SizedBox(height: 10),
                      ...[
                        'Scan the QR code and pay exactly $fee',
                        'Take a screenshot of your payment confirmation',
                        'Upload the screenshot on the next screen',
                        'Your entry will be verified within 10 minutes',
                      ].asMap().entries.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${e.key+1}. ', style: CrimsonText.mono(size: 12, color: CrimsonColors.blue)),
                          Expanded(child: Text(e.value, style: CrimsonText.body(size: 13, color: CrimsonColors.text))),
                        ]),
                      )),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  NeonButton(
                    label: 'I\'VE PAID — UPLOAD SCREENSHOT →',
                    width: double.infinity,
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UploadScreen(regKey: regKey, ign: ign, matchType: matchType, fee: fee))),
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ══════════════════════════════════════════════════════════════
//  UPLOAD SCREEN
// ══════════════════════════════════════════════════════════════
class UploadScreen extends StatefulWidget {
  final String regKey, ign, matchType, fee;
  const UploadScreen({super.key, required this.regKey, required this.ign, required this.matchType, required this.fee});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _image;
  bool _uploading = false;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _submit() async {
    if (_image == null) { showCrimsonToast(context, '⚠ Please select your payment screenshot!', isError: true); return; }
    setState(() => _uploading = true);
    try {
      final bytes = await _image!.readAsBytes();
      final caption = '💳 PAYMENT SCREENSHOT\nKey: ${widget.regKey}\nIGN: ${widget.ign}\nMode: ${widget.matchType}\nFee: ${widget.fee}';
      await TelegramService.sendPhoto(bytes, caption);
      await FirebaseService.updateScreenshotStatus(widget.regKey, 'uploaded');
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WaitingScreen(regKey: widget.regKey)));
    } catch (e) {
      if (mounted) showCrimsonToast(context, '⚠ Upload failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GridBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(children: [
                GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(border: Border.all(color: CrimsonColors.border), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.arrow_back_ios_new, size: 16, color: CrimsonColors.blueGlow))),
                const SizedBox(width: 16),
                Text('UPLOAD PROOF', style: CrimsonText.hud(size: 16, weight: FontWeight.w700)),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 240,
                      decoration: BoxDecoration(
                        color: _image != null ? Colors.transparent : CrimsonColors.panel,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _image != null ? CrimsonColors.green : CrimsonColors.border, width: _image != null ? 2 : 1, style: _image != null ? BorderStyle.solid : BorderStyle.solid),
                      ),
                      child: _image != null
                        ? ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.file(_image!, fit: BoxFit.cover, width: double.infinity))
                        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.cloud_upload_outlined, size: 56, color: CrimsonColors.blue.withOpacity(0.6)),
                            const SizedBox(height: 12),
                            Text('TAP TO SELECT SCREENSHOT', style: CrimsonText.mono(size: 12, color: CrimsonColors.muted)),
                            const SizedBox(height: 4),
                            Text('Payment proof from gallery', style: CrimsonText.body(size: 12, color: CrimsonColors.muted)),
                          ]),
                    ),
                  ),
                  if (_image != null) ...[
                    const SizedBox(height: 12),
                    NeonSecondaryButton(label: '🔄 CHANGE IMAGE', onPressed: _pickImage),
                  ],
                  const SizedBox(height: 24),
                  NeonButton(label: '📤  SUBMIT SCREENSHOT', width: double.infinity, isLoading: _uploading, onPressed: _submit),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ══════════════════════════════════════════════════════════════
//  WAITING / STATUS SCREEN
// ══════════════════════════════════════════════════════════════
class WaitingScreen extends StatefulWidget {
  final String regKey;
  const WaitingScreen({super.key, required this.regKey});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> with TickerProviderStateMixin {
  String _status   = 'pending';
  String _roomId   = '—';
  String _roomPass = '—';
  late AnimationController _pulseCtrl;
  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _sub = FirebaseService.watchRegistration(widget.regKey).listen((event) {
      if (!event.snapshot.exists || !mounted) return;
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        _status   = data['status']   ?? 'pending';
        _roomId   = data['roomId']   ?? '—';
        _roomPass = data['roomPass'] ?? '—';
      });
    });
  }

  @override
  void dispose() { _pulseCtrl.dispose(); _sub.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GridBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              // Status indicator
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) => Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _statusColor.withOpacity(0.1 + _pulseCtrl.value * 0.1),
                    border: Border.all(color: _statusColor.withOpacity(0.6 + _pulseCtrl.value * 0.4), width: 2),
                    boxShadow: [BoxShadow(color: _statusColor.withOpacity(0.3), blurRadius: 30 + _pulseCtrl.value * 20, spreadRadius: 5)],
                  ),
                  child: Center(child: Text(_statusIcon, style: const TextStyle(fontSize: 40))),
                ),
              ),

              const SizedBox(height: 24),
              Text(_statusTitle, style: CrimsonText.hud(size: 22, weight: FontWeight.w700, color: _statusColor), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(_statusDesc, style: CrimsonText.body(size: 14, color: CrimsonColors.muted), textAlign: TextAlign.center),

              const GlowDivider(),

              // Registration ID
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('REGISTRATION ID', style: CrimsonText.mono(size: 10, color: CrimsonColors.muted)),
                  Text('CA-${widget.regKey.substring(0,6).toUpperCase()}', style: CrimsonText.hud(size: 13, color: CrimsonColors.cyan)),
                ]),
              ),

              const SizedBox(height: 16),

              // Room creds (only when approved)
              if (_status == 'approved' || _roomId != '—') ...[
                GlassCard(
                  borderColor: CrimsonColors.green.withOpacity(0.4),
                  child: Column(children: [
                    Text('🔓 ROOM CREDENTIALS', style: CrimsonText.hud(size: 14, weight: FontWeight.w700, color: CrimsonColors.greenL)),
                    const SizedBox(height: 16),
                    _CredRow(label: 'ROOM ID',   value: _roomId),
                    const SizedBox(height: 8),
                    _CredRow(label: 'PASSWORD',  value: _roomPass),
                    const SizedBox(height: 12),
                    NeonSecondaryButton(
                      label: '📋 COPY CREDENTIALS',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: 'Room ID: $_roomId\nPassword: $_roomPass'));
                        showCrimsonToast(context, '✅ Credentials copied!');
                      },
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
              ],

              // Rejected
              if (_status == 'rejected') ...[
                GlassCard(
                  borderColor: CrimsonColors.crimson.withOpacity(0.4),
                  child: Column(children: [
                    Text('❌ REGISTRATION REJECTED', style: CrimsonText.hud(size: 14, color: CrimsonColors.crimsonL)),
                    const SizedBox(height: 8),
                    Text('Your payment could not be verified. Please contact admin or try again.', style: CrimsonText.body(size: 13, color: CrimsonColors.muted), textAlign: TextAlign.center),
                  ]),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
  );

  Color get _statusColor {
    switch (_status) {
      case 'approved': return CrimsonColors.greenL;
      case 'rejected': return CrimsonColors.crimsonL;
      default:         return CrimsonColors.blueGlow;
    }
  }

  String get _statusIcon {
    switch (_status) {
      case 'approved': return '✅';
      case 'rejected': return '❌';
      default:         return '⏳';
    }
  }

  String get _statusTitle {
    switch (_status) {
      case 'approved': return 'PAYMENT VERIFIED!';
      case 'rejected': return 'VERIFICATION FAILED';
      default:         return 'AWAITING VERIFICATION';
    }
  }

  String get _statusDesc {
    switch (_status) {
      case 'approved': return 'Your payment has been verified. Room credentials are ready!';
      case 'rejected': return 'Payment verification failed. Contact admin for support.';
      default:         return 'Admin is verifying your payment. This usually takes 5-10 minutes.';
    }
  }
}

class _CredRow extends StatelessWidget {
  final String label, value;
  const _CredRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: CrimsonText.mono(size: 10, color: CrimsonColors.muted)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: CrimsonColors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: CrimsonColors.green.withOpacity(0.3))),
        child: Text(value, style: CrimsonText.hud(size: 14, weight: FontWeight.w700, color: CrimsonColors.greenL)),
      ),
    ],
  );
}

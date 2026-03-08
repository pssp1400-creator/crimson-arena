import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../services/firebase_service.dart';
import '../services/telegram_service.dart';
import 'receipt_screen.dart';

class RegisterScreen extends StatefulWidget {
  final String matchType, skillMode, targetArea, fee, winPrize;
  const RegisterScreen({super.key, required this.matchType, required this.skillMode, required this.targetArea, required this.fee, required this.winPrize});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _ignCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _teamCtrl  = TextEditingController();
  bool _loading = false;

  @override
  void dispose() { _ignCtrl.dispose(); _phoneCtrl.dispose(); _teamCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_ignCtrl.text.trim().isEmpty) { showCrimsonToast(context, '⚠ Enter your IGN!', isError: true); return; }
    if (_phoneCtrl.text.trim().isEmpty) { showCrimsonToast(context, '⚠ Enter your phone number!', isError: true); return; }
    if (widget.matchType == '4v4' && _teamCtrl.text.trim().isEmpty) { showCrimsonToast(context, '⚠ Enter your team name!', isError: true); return; }

    setState(() => _loading = true);
    try {
      final data = {
        'ign':        _ignCtrl.text.trim(),
        'phone':      _phoneCtrl.text.trim(),
        'team':       _teamCtrl.text.trim(),
        'matchType':  widget.matchType,
        'skillMode':  widget.skillMode,
        'targetArea': widget.targetArea,
        'fee':        '₹${widget.fee}',
        'winPrize':   '₹${widget.winPrize}',
      };
      final key = await FirebaseService.submitRegistration(data);

      // Notify admin via Telegram
      await TelegramService.sendMessage(
        '🎮 <b>NEW REGISTRATION</b>\n'
        '━━━━━━━━━━━━━━━━━━━━\n'
        '🆔 Key: <code>$key</code>\n'
        '👤 IGN: ${_ignCtrl.text.trim()}\n'
        '📱 Phone: ${_phoneCtrl.text.trim()}\n'
        '${widget.matchType == '4v4' ? '🏆 Team: ${_teamCtrl.text.trim()}\n' : ''}'
        '🎯 Mode: ${widget.matchType.toUpperCase()} | ${widget.skillMode}\n'
        '💰 Entry: ₹${widget.fee}  •  Win: ₹${widget.winPrize}\n'
        '━━━━━━━━━━━━━━━━━━━━',
      );

      if (mounted) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ReceiptScreen(regKey: key, ign: _ignCtrl.text.trim(), team: _teamCtrl.text.trim(), matchType: widget.matchType, skillMode: widget.skillMode, targetArea: widget.targetArea, fee: '₹${widget.fee}', winPrize: '₹${widget.winPrize}'),
        ));
      }
    } catch (e) {
      if (mounted) showCrimsonToast(context, '⚠ Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
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
                Text('REGISTER', style: CrimsonText.hud(size: 16, weight: FontWeight.w700)),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      borderColor: CrimsonColors.purple.withOpacity(0.4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        _SummaryItem(label: 'MODE',  value: widget.matchType.toUpperCase()),
                        _SummaryItem(label: 'SKILL', value: widget.skillMode.toUpperCase()),
                        _SummaryItem(label: 'FEE',   value: '₹${widget.fee}'),
                        _SummaryItem(label: 'WIN',   value: '₹${widget.winPrize}', color: CrimsonColors.greenL),
                      ]),
                    ),

                    const SizedBox(height: 28),

                    Text('PLAYER DETAILS', style: CrimsonText.mono(size: 11, color: CrimsonColors.cyan)),
                    const SizedBox(height: 16),

                    _Field(label: 'IN-GAME NAME (IGN) *', hint: 'Your Free Fire IGN', controller: _ignCtrl),
                    const SizedBox(height: 16),
                    _Field(label: 'PHONE NUMBER *', hint: '10-digit mobile number', controller: _phoneCtrl, keyboardType: TextInputType.phone),

                    if (widget.matchType == '4v4') ...[
                      const SizedBox(height: 16),
                      _Field(label: 'TEAM NAME *', hint: 'Your team name', controller: _teamCtrl),
                    ],

                    const SizedBox(height: 32),

                    // Rules checkbox
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('MATCH RULES', style: CrimsonText.mono(size: 11, color: CrimsonColors.muted)),
                        const SizedBox(height: 10),
                        ..._rules.map((r) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('▸ ', style: CrimsonText.mono(size: 12, color: CrimsonColors.blue)),
                          Expanded(child: Text(r, style: CrimsonText.body(size: 12, color: CrimsonColors.muted))),
                        ]))),
                      ]),
                    ),

                    const SizedBox(height: 24),

                    NeonButton(label: 'GENERATE RECEIPT →', width: double.infinity, isLoading: _loading, onPressed: _submit),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Field extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _Field({required this.label, required this.hint, required this.controller, this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: CrimsonText.mono(size: 10, color: CrimsonColors.muted)),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: CrimsonText.body(size: 15, color: CrimsonColors.text),
        decoration: InputDecoration(hintText: hint),
      ),
    ],
  );
}

class _SummaryItem extends StatelessWidget {
  final String label, value;
  final Color color;
  const _SummaryItem({required this.label, required this.value, this.color = CrimsonColors.blueGlow});

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(label, style: CrimsonText.mono(size: 9, color: CrimsonColors.muted)),
    const SizedBox(height: 4),
    Text(value, style: CrimsonText.hud(size: 12, weight: FontWeight.w700, color: color)),
  ]);
}

const _rules = [
  'No teaming, cheating, or hacking — instant disqualification.',
  'Payment must be made before match start.',
  'Screenshot proof required within 10 minutes of payment.',
  'Room details shared 5 minutes before match.',
  'Results are final — admin decision is binding.',
];

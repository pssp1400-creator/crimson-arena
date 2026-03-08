import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import 'register_screen.dart';

class MatchSelectScreen extends StatefulWidget {
  const MatchSelectScreen({super.key});

  @override
  State<MatchSelectScreen> createState() => _MatchSelectScreenState();
}

class _MatchSelectScreenState extends State<MatchSelectScreen> {
  String _matchType  = 'solo';
  String _skillMode  = 'beginner';
  String _targetArea = 'chest';
  String _feeTier    = '10';
  String _winPrize   = '18';

  final _feeTiers = [
    {'fee': '10',  'win': '18',  'label': '₹10  Entry  •  Win ₹18'},
    {'fee': '20',  'win': '36',  'label': '₹20  Entry  •  Win ₹36'},
    {'fee': '50',  'win': '90',  'label': '₹50  Entry  •  Win ₹90'},
    {'fee': '100', 'win': '180', 'label': '₹100 Entry  •  Win ₹180'},
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GridBackground(
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: CrimsonColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 16, color: CrimsonColors.blueGlow),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('SELECT MATCH', style: CrimsonText.hud(size: 16, weight: FontWeight.w700)),
                ],
              ),
            ),

            // ── Step Progress ────────────────────────────────────
            _StepBar(activeStep: 0),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Match Type ─────────────────────────────────
                    Text('MATCH TYPE', style: CrimsonText.mono(size: 11, color: CrimsonColors.muted)),
                    const SizedBox(height: 12),
                    Row(children: [
                      _TypeChip(label: 'SOLO', value: 'solo', selected: _matchType == 'solo', onTap: () => setState(() => _matchType = 'solo')),
                      const SizedBox(width: 12),
                      _TypeChip(label: '4v4', value: '4v4',   selected: _matchType == '4v4',  onTap: () => setState(() => _matchType = '4v4')),
                    ]),

                    const SizedBox(height: 24),

                    // ── Skill Mode ─────────────────────────────────
                    Text('SKILL MODE', style: CrimsonText.mono(size: 11, color: CrimsonColors.muted)),
                    const SizedBox(height: 12),
                    Wrap(spacing: 10, runSpacing: 10, children: [
                      _TypeChip(label: 'BEGINNER', value: 'beginner', selected: _skillMode == 'beginner', onTap: () => setState(() => _skillMode = 'beginner')),
                      _TypeChip(label: 'INTERMEDIATE', value: 'intermediate', selected: _skillMode == 'intermediate', onTap: () => setState(() => _skillMode = 'intermediate')),
                      _TypeChip(label: 'PRO', value: 'pro', selected: _skillMode == 'pro', onTap: () => setState(() => _skillMode = 'pro')),
                    ]),

                    const SizedBox(height: 24),

                    // ── Target Area ────────────────────────────────
                    Text('TARGET AREA', style: CrimsonText.mono(size: 11, color: CrimsonColors.muted)),
                    const SizedBox(height: 12),
                    Wrap(spacing: 10, runSpacing: 10, children: [
                      _TypeChip(label: 'CHEST',    value: 'chest',    selected: _targetArea == 'chest',    onTap: () => setState(() => _targetArea = 'chest')),
                      _TypeChip(label: 'HEAD',     value: 'head',     selected: _targetArea == 'head',     onTap: () => setState(() => _targetArea = 'head')),
                      _TypeChip(label: 'ANYWHERE', value: 'anywhere', selected: _targetArea == 'anywhere', onTap: () => setState(() => _targetArea = 'anywhere')),
                    ]),

                    const SizedBox(height: 24),

                    // ── Fee Tier ───────────────────────────────────
                    Text('ENTRY FEE TIER', style: CrimsonText.mono(size: 11, color: CrimsonColors.muted)),
                    const SizedBox(height: 12),
                    ..._feeTiers.map((tier) => _FeeTileCard(
                      fee: tier['fee']!, win: tier['win']!, label: tier['label']!,
                      selected: _feeTier == tier['fee'],
                      onTap: () => setState(() { _feeTier = tier['fee']!; _winPrize = tier['win']!; }),
                    )),

                    const SizedBox(height: 32),

                    // ── Summary Bar ────────────────────────────────
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      borderColor: CrimsonColors.blue.withOpacity(0.4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('ENTRY FEE', style: CrimsonText.mono(size: 10, color: CrimsonColors.muted)),
                            Text('₹$_feeTier', style: CrimsonText.hud(size: 22, weight: FontWeight.w700, color: CrimsonColors.blueGlow)),
                          ]),
                          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Text('WIN PRIZE', style: CrimsonText.mono(size: 10, color: CrimsonColors.muted)),
                            Text('₹$_winPrize', style: CrimsonText.hud(size: 22, weight: FontWeight.w700, color: CrimsonColors.greenL)),
                          ]),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text('MODE', style: CrimsonText.mono(size: 10, color: CrimsonColors.muted)),
                            Text(_matchType.toUpperCase(), style: CrimsonText.hud(size: 14, color: CrimsonColors.purpleGl)),
                          ]),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    NeonButton(
                      label: 'CONTINUE TO REGISTER →',
                      width: double.infinity,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => RegisterScreen(matchType: _matchType, skillMode: _skillMode, targetArea: _targetArea, fee: _feeTier, winPrize: _winPrize),
                      )),
                    ),
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

class _TypeChip extends StatelessWidget {
  final String label, value;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? CrimsonColors.blue.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: selected ? CrimsonColors.blue : CrimsonColors.border, width: selected ? 1.5 : 1),
        boxShadow: selected ? [BoxShadow(color: CrimsonColors.blue.withOpacity(0.3), blurRadius: 12)] : null,
      ),
      child: Text(label, style: CrimsonText.hud(size: 11, weight: FontWeight.w700, color: selected ? CrimsonColors.blueGlow : CrimsonColors.muted)),
    ),
  );
}

class _FeeTileCard extends StatelessWidget {
  final String fee, win, label;
  final bool selected;
  final VoidCallback onTap;

  const _FeeTileCard({required this.fee, required this.win, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? CrimsonColors.purple.withOpacity(0.12) : CrimsonColors.panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selected ? CrimsonColors.purple : CrimsonColors.border, width: selected ? 1.5 : 1),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 18, height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? CrimsonColors.purple : Colors.transparent,
              border: Border.all(color: selected ? CrimsonColors.purple : CrimsonColors.muted, width: 1.5),
            ),
            child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
          ),
          const SizedBox(width: 14),
          Text(label, style: CrimsonText.mono(size: 13, color: selected ? CrimsonColors.purpleGl : CrimsonColors.text)),
          const Spacer(),
          Text('WIN ₹$win', style: CrimsonText.hud(size: 12, color: CrimsonColors.greenL)),
        ],
      ),
    ),
  );
}

class _StepBar extends StatelessWidget {
  final int activeStep;
  const _StepBar({required this.activeStep});

  static const steps = ['Mode', 'Register', 'Receipt', 'Payment', 'Upload'];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: Row(
      children: steps.asMap().entries.map((e) {
        final done   = e.key < activeStep;
        final active = e.key == activeStep;
        return Expanded(child: Row(children: [
          Column(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28, height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? CrimsonColors.greenL : active ? CrimsonColors.blue : Colors.transparent,
                border: Border.all(color: done ? CrimsonColors.greenL : active ? CrimsonColors.blue : CrimsonColors.border),
              ),
              child: Center(child: done
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text('${e.key+1}', style: CrimsonText.mono(size: 11, color: active ? Colors.white : CrimsonColors.muted))),
            ),
            const SizedBox(height: 4),
            Text(e.value, style: CrimsonText.mono(size: 9, color: active ? CrimsonColors.blueGlow : CrimsonColors.muted)),
          ]),
          if (e.key < steps.length - 1)
            Expanded(child: Container(height: 1, margin: const EdgeInsets.only(bottom: 18), color: done ? CrimsonColors.greenL.withOpacity(0.5) : CrimsonColors.border)),
        ]));
      }).toList(),
    ),
  );
}

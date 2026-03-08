import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_database/firebase_database.dart';
import '../theme.dart';
import '../widgets/widgets.dart';
import '../services/firebase_service.dart';
import 'match_select_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _siteOpen = true;

  @override
  void initState() {
    super.initState();
    FirebaseService.watchSiteStatus().listen((event) {
      if (mounted && event.snapshot.exists) {
        setState(() => _siteOpen = event.snapshot.value == true);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: GridBackground(
      child: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: CrimsonColors.bg.withOpacity(0.88),
            title: Row(
              children: [
                RichText(text: TextSpan(
                  style: CrimsonText.hud(size: 16, weight: FontWeight.w900),
                  children: [
                    TextSpan(text: 'CRIMSON ', style: TextStyle(color: CrimsonColors.crimsonL, shadows: neonCrimson)),
                    TextSpan(text: 'ARENA',    style: TextStyle(color: CrimsonColors.blueGlow, shadows: neonBlue)),
                  ],
                )),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: CrimsonColors.green),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('● LIVE', style: CrimsonText.mono(size: 11, color: CrimsonColors.green)),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // ── Hero Section ─────────────────────────
                  Text('SKILL-BASED', style: CrimsonText.mono(size: 12, color: CrimsonColors.cyan))
                    .animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 12),

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [CrimsonColors.crimson, CrimsonColors.purple, CrimsonColors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text('CRIMSON\nARENA', style: CrimsonText.hud(size: 52, weight: FontWeight.w900, color: Colors.white), textAlign: TextAlign.center),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),

                  const SizedBox(height: 16),

                  Text('COMPETE · WIN · DOMINATE', style: CrimsonText.body(size: 16, weight: FontWeight.w600, color: CrimsonColors.muted), letterSpacing: 4, textAlign: TextAlign.center)
                    .animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 40),

                  // ── CTA Buttons ───────────────────────────
                  if (_siteOpen) ...[
                    NeonButton(
                      label: '⚡  ENTER THE ARENA',
                      width: double.infinity,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchSelectScreen())),
                    ).animate().fadeIn(delay: 800.ms).scale(),
                    const SizedBox(height: 12),
                    NeonSecondaryButton(
                      label: 'HOW IT WORKS',
                      onPressed: () => _showHowItWorks(context),
                    ).animate().fadeIn(delay: 900.ms),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CrimsonColors.crimson.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: CrimsonColors.crimson.withOpacity(0.4)),
                      ),
                      child: Column(children: [
                        Text('⚠', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text('ARENA CLOSED', style: CrimsonText.hud(size: 18, color: CrimsonColors.crimsonL)),
                        const SizedBox(height: 4),
                        Text('Registrations are currently closed. Check back soon!', style: CrimsonText.body(size: 14, color: CrimsonColors.muted), textAlign: TextAlign.center),
                      ]),
                    ),
                  ],

                  const GlowDivider(),

                  // ── Match Cards ───────────────────────────
                  const SectionHeader(eyebrow: '// ACTIVE MODES', title: 'CHOOSE YOUR BATTLEFIELD'),
                  const SizedBox(height: 32),

                  _MatchCard(icon: '🎯', mode: 'SOLO', title: 'FREE FIRE', desc: 'Battle Royale — Last squad standing wins the prize pool.', badge: 'ACTIVE', badgeColor: CrimsonColors.greenL, onEnter: _siteOpen ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchSelectScreen())) : null),
                  const SizedBox(height: 16),
                  _MatchCard(icon: '💥', mode: '4v4', title: 'CLASH SQUAD', desc: 'Team tactical mode — Coordinate and eliminate. Maximum skill required.', badge: 'HOT', badgeColor: CrimsonColors.crimsonL, onEnter: _siteOpen ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchSelectScreen())) : null),
                  const SizedBox(height: 16),
                  _MatchCard(icon: '🏆', mode: 'TOURNAMENT', title: 'RANKED CUP', desc: 'Compete for glory. Massive prize pools and bragging rights.', badge: 'COMING SOON', badgeColor: CrimsonColors.muted, onEnter: null),

                  const GlowDivider(),

                  // ── How it works ──────────────────────────
                  const SectionHeader(eyebrow: '// HOW IT WORKS', title: 'ENTER IN 4 EASY STEPS'),
                  const SizedBox(height: 28),

                  ..._steps.asMap().entries.map((e) => _StepRow(index: e.key + 1, step: e.value).animate().fadeIn(delay: (200 * e.key).ms).slideX(begin: -0.2)),

                  const GlowDivider(),

                  // ── QR Code / UPI ─────────────────────────
                  const SectionHeader(eyebrow: '// PAYMENT', title: 'SCAN TO PAY'),
                  const SizedBox(height: 20),
                  GlassCard(
                    child: Column(
                      children: [
                        Text('UPI PAYMENT QR', style: CrimsonText.mono(size: 11, color: CrimsonColors.muted)),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset('assets/qr.png', width: 220, height: 220, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 12),
                        Text('After payment, upload your screenshot\nin the registration flow.', style: CrimsonText.body(size: 13, color: CrimsonColors.muted), textAlign: TextAlign.center),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Footer ────────────────────────────────
                  Text('CRIMSON ARENA © 2024', style: CrimsonText.mono(size: 11, color: CrimsonColors.muted)),
                  const SizedBox(height: 4),
                  Text('Fair play · Real prizes · Zero bots', style: CrimsonText.body(size: 12, color: CrimsonColors.muted)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  void _showHowItWorks(BuildContext context) => showModalBottomSheet(
    context: context,
    backgroundColor: CrimsonColors.bg2,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HOW IT WORKS', style: CrimsonText.hud(size: 18, weight: FontWeight.w700, color: CrimsonColors.blueGlow)),
          const SizedBox(height: 20),
          ..._steps.asMap().entries.map((e) => _StepRow(index: e.key + 1, step: e.value)),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

const _steps = [
  {'icon': '1️⃣', 'title': 'Pick Your Mode',    'desc': 'Choose Solo or 4v4, select your skill tier and entry fee.'},
  {'icon': '2️⃣', 'title': 'Register & Pay',    'desc': 'Fill in your IGN and complete payment via UPI.'},
  {'icon': '3️⃣', 'title': 'Upload Screenshot', 'desc': 'Send your payment screenshot for quick verification.'},
  {'icon': '4️⃣', 'title': 'Get Room Details',  'desc': 'Receive room ID & password 5 minutes before match start.'},
];

class _StepRow extends StatelessWidget {
  final int index;
  final Map<String, String> step;

  const _StepRow({required this.index, required this.step});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: CrimsonColors.blue.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: CrimsonColors.blue.withOpacity(0.4)),
          ),
          child: Center(child: Text('$index', style: CrimsonText.hud(size: 13, color: CrimsonColors.blueGlow))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(step['title']!, style: CrimsonText.hud(size: 13, weight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 3),
            Text(step['desc']!,  style: CrimsonText.body(size: 13, color: CrimsonColors.muted)),
          ],
        )),
      ],
    ),
  );
}

class _MatchCard extends StatelessWidget {
  final String icon, mode, title, desc, badge;
  final Color badgeColor;
  final VoidCallback? onEnter;

  const _MatchCard({required this.icon, required this.mode, required this.title, required this.desc, required this.badge, required this.badgeColor, this.onEnter});

  @override
  Widget build(BuildContext context) => GlassCard(
    borderRadius: 16,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const Spacer(),
          NeonBadge(label: badge, color: badgeColor),
        ]),
        const SizedBox(height: 12),
        Text(mode,  style: CrimsonText.mono(size: 10, color: CrimsonColors.muted)),
        const SizedBox(height: 4),
        Text(title, style: CrimsonText.hud(size: 20, weight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 8),
        Text(desc,  style: CrimsonText.body(size: 13, color: CrimsonColors.muted)),
        if (onEnter != null) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: NeonButton(label: 'ENTER NOW', onPressed: onEnter),
          ),
        ],
      ],
    ),
  );
}

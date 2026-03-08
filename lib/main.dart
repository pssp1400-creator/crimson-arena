import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'services/firebase_service.dart';

final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: CrimsonColors.bg,
  ));

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Local notifications
  await _localNotifications.initialize(
    const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
  );

  await FirebaseService.initNotifications();

  // Show foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final n = message.notification;
    if (n != null) {
      _localNotifications.show(
        message.hashCode,
        n.title,
        n.body,
        NotificationDetails(android: AndroidNotificationDetails(
          'crimson_arena',
          'Crimson Arena',
          channelDescription: 'Match updates and alerts',
          importance: Importance.high,
          priority: Priority.high,
          color: CrimsonColors.crimson,
        )),
      );
    }
  });

  runApp(const CrimsonArenaApp());
}

class CrimsonArenaApp extends StatelessWidget {
  const CrimsonArenaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Crimson Arena',
    theme: crimsonTheme,
    debugShowCheckedModeBanner: false,
    home: const SplashScreen(),
  );
}

// ── Splash Screen ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade  = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _scale = Tween<double>(begin: 0.7, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _ctrl.forward().then((_) => Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: CrimsonColors.bg,
    body: Stack(children: [
      // Radial bg glow
      Center(child: Container(width: 300, height: 300, decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [CrimsonColors.crimson.withOpacity(0.2), Colors.transparent]),
      ))),
      Center(child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [CrimsonColors.crimson, CrimsonColors.purple, CrimsonColors.blue],
                ).createShader(bounds),
                child: Text('⚡', style: const TextStyle(fontSize: 72, color: Colors.white)),
              ),
              const SizedBox(height: 24),
              RichText(text: TextSpan(
                style: CrimsonText.hud(size: 32, weight: FontWeight.w900),
                children: [
                  TextSpan(text: 'CRIMSON ', style: TextStyle(color: CrimsonColors.crimsonL, shadows: neonCrimson)),
                  TextSpan(text: 'ARENA',    style: TextStyle(color: CrimsonColors.blueGlow, shadows: neonBlue)),
                ],
              )),
              const SizedBox(height: 8),
              Text('SKILL-BASED CUSTOM ROOM MATCHES', style: CrimsonText.mono(size: 10, color: CrimsonColors.muted)),
            ]),
          ),
        ),
      )),
    ]),
  );
}

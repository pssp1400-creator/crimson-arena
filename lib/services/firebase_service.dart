import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final _db  = FirebaseDatabase.instance.ref();
  static final _msg = FirebaseMessaging.instance;

  // ── FCM Push Notifications ──────────────────────────────
  static Future<void> initNotifications() async {
    await _msg.requestPermission(alert: true, badge: true, sound: true);
    await _msg.subscribeToTopic('crimson_arena_users');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // handled by local notifications in main.dart
    });
  }

  // ── Registration ─────────────────────────────────────────
  static Future<String> submitRegistration(Map<String, dynamic> data) async {
    final ref  = _db.child('registrations').push();
    final key  = ref.key!;
    final now  = DateTime.now();
    await ref.set({
      ...data,
      'key':       key,
      'status':    'pending',
      'timestamp': now.millisecondsSinceEpoch,
      'dateStr':   '${now.day}/${now.month}/${now.year}',
      'timeStr':   '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}',
    });
    return key;
  }

  // ── Listen to single registration ────────────────────────
  static Stream<DatabaseEvent> watchRegistration(String key) =>
    _db.child('registrations/$key').onValue;

  // ── Upload payment screenshot path ───────────────────────
  static Future<void> updateScreenshotStatus(String key, String status) async {
    await _db.child('registrations/$key').update({'screenshotStatus': status});
  }

  // ── Site status ──────────────────────────────────────────
  static Stream<DatabaseEvent> watchSiteStatus() =>
    _db.child('siteStatus').onValue;

  // ── Leaderboard ──────────────────────────────────────────
  static Future<List<Map>> getLeaderboard() async {
    final snap = await _db.child('leaderboard').orderByChild('wins').limitToLast(10).get();
    if (!snap.exists) return [];
    final List<Map> list = [];
    for (final child in snap.children) {
      list.add(Map<String, dynamic>.from(child.value as Map));
    }
    return list.reversed.toList();
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheService {
  static const String _keyStudentData = 'thebes_student_data_cache';
  static const String _keySchedule = 'thebes_schedule_cache';
  static const String _keyAttendance = 'thebes_attendance_cache';
  static const String _keyNotifications = 'thebes_notifications_cache';
  static const String _keyLastSync = 'thebes_last_sync_timestamp';

  final Map<String, String> _memoryFallback = {};
  SharedPreferences? _prefsInstance;

  LocalCacheService([this._prefsInstance]);

  Future<SharedPreferences?> _getPrefs() async {
    if (_prefsInstance != null) return _prefsInstance;
    try {
      _prefsInstance = await SharedPreferences.getInstance();
      return _prefsInstance;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveString(String key, String value) async {
    _memoryFallback[key] = value;
    final prefs = await _getPrefs();
    if (prefs != null) {
      await prefs.setString(key, value);
    }
  }

  Future<String?> getString(String key) async {
    final prefs = await _getPrefs();
    if (prefs != null && prefs.containsKey(key)) {
      return prefs.getString(key);
    }
    return _memoryFallback[key];
  }

  // --- Specialized Cache Methods ---

  Future<void> cacheStudentJson(Map<String, dynamic> data) async {
    await saveString(_keyStudentData, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getCachedStudentJson() async {
    final raw = await getString(_keyStudentData);
    if (raw != null && raw.isNotEmpty) {
      try {
        return jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {}
    }
    return null;
  }

  Future<void> cacheScheduleJson(List<Map<String, dynamic>> list) async {
    await saveString(_keySchedule, jsonEncode(list));
  }

  Future<List<Map<String, dynamic>>?> getCachedScheduleJson() async {
    final raw = await getString(_keySchedule);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as List;
        return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } catch (_) {}
    }
    return null;
  }

  Future<void> cacheAttendanceJson(List<Map<String, dynamic>> list) async {
    await saveString(_keyAttendance, jsonEncode(list));
  }

  Future<List<Map<String, dynamic>>?> getCachedAttendanceJson() async {
    final raw = await getString(_keyAttendance);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as List;
        return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } catch (_) {}
    }
    return null;
  }

  Future<void> cacheNotificationsJson(List<Map<String, dynamic>> list) async {
    await saveString(_keyNotifications, jsonEncode(list));
  }

  Future<List<Map<String, dynamic>>?> getCachedNotificationsJson() async {
    final raw = await getString(_keyNotifications);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as List;
        return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } catch (_) {}
    }
    return null;
  }

  Future<void> updateLastSync(DateTime time) async {
    await saveString(_keyLastSync, time.toIso8601String());
  }

  Future<DateTime?> getLastSync() async {
    final raw = await getString(_keyLastSync);
    if (raw != null && raw.isNotEmpty) {
      try {
        return DateTime.parse(raw);
      } catch (_) {}
    }
    return null;
  }
}

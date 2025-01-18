import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension StringExt on String? {
  String? get orNull => this?.isEmpty == true ? null : this;
}

typedef ModelOrId<T> = (String, T?);

extension ModelOrIdExtension<T> on ModelOrId<T> {
  String get id => $1;
  T? get model => $2;
  bool get hasModel => $2 != null;
}

extension NumExt on num {
  String toCurrency(Locale locale) => NumberFormat(
        ',##0.##',
        locale.toLanguageTag(),
      ).format(this);
}

final pretyEncoder = JsonEncoder.withIndent('  ');

extension JsonExt on Map<String, dynamic> {
  String get pretty => pretyEncoder.convert(this);
}

extension SharedPreferencesCache on SharedPreferences {
  Future<T> cached<T>({
    required String key,
    required Future<T> Function() fetch,
    required String Function(T) encode,
    required T Function(String) decode,
    Duration? expiresIn = const Duration(minutes: 1),
    bool force = false,
  }) async {
    if (!force) {
      final json = getString(key);
      final expires = getInt('${key}_expires');
      if (json != null &&
          expires != null &&
          DateTime.now().millisecondsSinceEpoch < expires) {
        return decode(json);
      }
    }

    final data = await fetch();
    await setString(key, encode(data));
    await setInt('${key}_expires',
        DateTime.now().add(expiresIn!).millisecondsSinceEpoch);
    final cache = getStringList('cache') ?? [];
    await setStringList('cache', [...cache, key]);
    return data;
  }

  Future<void> clearCache(String key) async {
    await remove(key);
    await remove('${key}_expires');
    final cache = getStringList('cache') ?? [];
    await setStringList('cache', cache..remove(key));
  }

  Future<void> clearAllCache() async {
    final cache = getStringList('cache') ?? [];
    for (final key in cache) {
      await remove(key);
      await remove('${key}_expires');
    }
    await remove('cache');
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

import 'package:flutter/foundation.dart';

const pocketbaseUrl = kReleaseMode
    ? String.fromEnvironment('POCKETBASE_URL')
    : 'http://127.0.0.1:8090';

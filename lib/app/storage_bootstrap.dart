// ABOUTME: Initializes platform-appropriate RpgStorage (web vs native) for app use.
// ABOUTME: Task 6 providers will read [rpgStorage]; set by main before runApp.

import 'package:flutter/foundation.dart';
import 'package:rpg/data/local_db.dart';
import 'package:rpg/data/storage.dart';
import 'package:rpg/data/storage_web.dart';

late RpgStorage rpgStorage;

void initRpgStorage() {
  rpgStorage = kIsWeb ? createWebRpgStorage() : createNativeRpgStorage();
}

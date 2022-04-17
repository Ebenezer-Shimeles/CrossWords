import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;

import 'service.dart';

import 'dart:io';

class DbService extends Service implements Disposable<void>, Initable<bool> {
  Map<String, Object> _tables = {};
  @override
  Future<bool> init() async {
    await Hive.initFlutter();
    Directory? dir = await getApplicationDocumentsDirectory();
    if (dir == null) return false;
    Hive.init(path.join(dir.path, "hive"));
    return true;
  }

  Future<bool> regTable<T>(String tblName) async {
    if (_tables.containsKey('$tblName')) {
      print("Error table already taken");
      return false;
    }
    final table = await Hive.openBox(tblName);
    if (table == null) {
      print("Cannot open box");
      return false;
    }
    _tables[tblName] = T;
    print("opened box $tblName");
    return true;
  }

  Future<bool> contains(String tblName, String key, Object svcInstance) async {
    if (!_tables.containsKey("$tblName")) {
      print("Read=>Error table '$tblName' doesn't Exist");
      return false;
    }
    final _box = Hive.box(tblName);
    if (_box == null) {
      print("Read=>Table does not exist!");
      return false;
    }
    return _box.containsKey("$key");
  }

  Future<dynamic?> read(String tblName, String key, Object svcInstance) async {
    if (!_tables.containsKey("$tblName")) {
      print("Read=>Error table '$tblName' doesn't Exist");
      return null;
    }
    final _box = Hive.box(tblName);
    if (_box == null) {
      print("Read=>Table does not exist!");
      return null;
    }
    print("Reading $key");
    final ret = await _box.get(key);

    return ret;
  }

  Future<bool> write(
      String tblName, String key, dynamic value, Object svcInstace) async {
    if (!_tables.containsKey("$tblName")) {
      print("Write =>Error table '$tblName' doesn't Exist");
      return false;
    }
    final _box = Hive.box(tblName);
    if (_box == null) {
      print(" Write =>Table doesnot exist!");
      return false;
    }
    await _box.put(key, value);
    print("$key=${value}");
    return true;
  }

  @override
  Future dispose() async {}
}

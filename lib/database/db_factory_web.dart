import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Web implementation: configures sqflite to use the sqlite3 WASM
/// backend provided by `sqflite_common_ffi_web`.
///
/// Remember to run `dart run sqflite_common_ffi_web:setup` once after adding
/// the dependency so the required WASM/JS files are copied to `web/`.
Future<void> initDatabaseFactory() async {
  databaseFactory = databaseFactoryFfiWeb;
}

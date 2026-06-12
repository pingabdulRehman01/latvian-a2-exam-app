// Conditionally exports a platform-appropriate `initDatabaseFactory()`.
//
// On mobile/desktop the stub is a no-op (sqflite's default factory works).
// On Flutter web we pull in sqflite_common_ffi_web and install its factory.
//
// Conditional imports avoid pulling web-only code into mobile/desktop builds.
export 'db_factory_stub.dart'
    if (dart.library.html) 'db_factory_web.dart';

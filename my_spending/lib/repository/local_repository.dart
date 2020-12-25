import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:myspending/ui/views/spendings/spending_model.dart';

class LocalRepository {
  /// Xây dựng một hàm tạo private
  LocalRepository._internal();

  /// Lưu cache để không phải tạo nhiều đối tượng
  static final _cache = <String, LocalRepository>{};

  /// Tạo một getter để lấy ra chính nó
  static LocalRepository get instance =>
      _cache.putIfAbsent('LocalPersistence', () => LocalRepository._internal());

  bool isInitialized = false;
  Database _db;

  Future<Database> db() async {
    if (!isInitialized) await _init();
    return _db;
  }

  Future _init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'spending_app.db');

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(Spending.createTable);
    });
    isInitialized = true;
  }
}

import 'package:myspending/repository/local_repository.dart';
import 'package:myspending/repository/repository.dart';

import 'spending_model.dart';

class SpendingRepository implements Repository<Spending> {
  SpendingRepository._internal(LocalRepository localRepo) {
    this.localRepo = localRepo;
  }

  static final _cache = <String, SpendingRepository>{};

  factory SpendingRepository() {
    return _cache.putIfAbsent('spendingRepository',
        () => SpendingRepository._internal(LocalRepository.instance));
  }

  @override
  LocalRepository localRepo;

  @override
  Future<dynamic> insert(Spending item) async {
    final db = await localRepo.db();
    return await db.insert(Spending.tableName, item.toMap());
  }

  @override
  Future<dynamic> update(Spending item) async {
    final db = await localRepo.db();
    return await db.update(Spending.tableName, item.toMap(),
        where: 'id = ?', whereArgs: [item.id]);
  }

  @override
  Future<dynamic> delete(Spending item) async {
    return await localRepo.db().then((db) => db.delete(Spending.tableName,
        where: 'id' + ' = ?', whereArgs: [item.id]));
  }

  @override
  Future<List<Spending>> items() async {
    final db = await localRepo.db();
    var maps = await db.query(Spending.tableName);
    return Spending.fromList(maps);
  }
}

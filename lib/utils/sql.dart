import './db_provider.dart';
import '../model/base.dart';

class Sql extends BaseModel {
  
  final String tableName;

  Sql.setTable(this.tableName) : super(DbProvider.db);

  // sdf
  Future<List> get() async {
    return await this.query(tableName);
  }

  Future<List> getBySql(String where, List<dynamic> whereArgs) async {
    return await this.query(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> rawUpdate(String sql, [List<dynamic> arguments]) async {
    return await this.db.rawUpdate('UPDATE $tableName SET $sql', arguments);
  }

  Future<int> rawInsert(String valueNames, [List<dynamic> arguments]) async {
    return await this.db.rawInsert('INSERT INTO $tableName$valueNames', arguments);
  }

  String getTableName() {
    return tableName;
  }

  Future<int> deleteAll() async {
    return await this.db.delete(tableName);
  }

}

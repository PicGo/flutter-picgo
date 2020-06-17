import './db_provider.dart';
import '../model/base.dart';

class Sql extends BaseModel {
  
  final String tableName;

  Sql.setTable(this.tableName) : super(DbProvider.db);

  // sdf
  Future<List> get() async {
    return await this.query(tableName);
  }

  String getTableName() {
    return tableName;
  }

  Future<int> delete(String value, String key) async {
    return await this
        .db
        .delete(tableName, where: '$key = ?', whereArgs: [value]);
  }

  Future<int> deleteAll() async {
    return await this.db.delete(tableName);
  }

}

import 'package:curso_persitencia_flutter/models/contact_model.dart';

import '../app_database.dart';

class ContactDAO {
  static const String tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  static const String tableSql = "CREATE TABLE $tableName("
      "$_id INTEGER PRIMARY KEY, "
      "$_name TEXT, "
      "$_accountNumber INTEGER)";

  Future<int> save(Contact contact) async {
    final database = await createDatabase();
    final map = contact.toMap();
    map.remove('id');

    return database.insert(tableName, map);
  }

  Future<List<Contact>> findAll() async {
    final database = await createDatabase();
    final maps = await database.query(tableName);
    return maps.map((e) => Contact.fromMap(e)).toList();
  }
}

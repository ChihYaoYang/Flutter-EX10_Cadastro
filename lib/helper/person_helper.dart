import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String personTable = "personTable";
final String idColumn = "id";
final String nomeColumn = "nome";
final String telefoneColumn = "telefone";

class PersonHelper {
  static final PersonHelper _instance = PersonHelper.internal();
  factory PersonHelper() => _instance;
  PersonHelper.internal();
  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "person.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $personTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $telefoneColumn TEXT)"
      );
    });
  }

  Future<Person> savePerson(Person person) async {
    Database dbPerson = await db;
    person.id = await dbPerson.insert(personTable, person.toMap());
    return person;
  }

  Future<Person> getPerson(int id) async {
    Database dbPerson = await db;
    List<Map> maps = await dbPerson.query(personTable,
        columns: [idColumn, nomeColumn, telefoneColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if(maps.length > 0){
      return Person.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletePerson(int id) async {
    Database dbPerson = await db;
    return await dbPerson.delete(personTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updatePerson(Person person) async {
    Database dbPerson = await db;
    return await dbPerson.update(personTable,
        person.toMap(),
        where: "$idColumn = ?",
        whereArgs: [person.id]);
  }

  Future<List> getAllPersons() async {
    Database dbPerson = await db;
    List listMap = await dbPerson.rawQuery("SELECT * FROM $personTable");
    List<Person> listPerson = List();
    for(Map m in listMap){
      listPerson.add(Person.fromMap(m));
    }
    return listPerson;
  }

  Future close() async {
    Database dbPerson = await db;
    dbPerson.close();
  }

}

class Person {
  int id;
  String nome;
  String telefone;

  Person();

  Person.fromMap(Map map){
    id = map[idColumn];
    nome = map[nomeColumn];
    telefone = map[telefoneColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      telefoneColumn: telefone
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Person(id: $id, name: $nome, telefone: $telefone)";
  }

}
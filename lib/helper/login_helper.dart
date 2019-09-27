import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String loginTable = "loginTableTable";
final String idColumn = "id";
final String emailColumn = "email";
final String senhaColumn = "senha";
//Session table
final String sessionTable = "sessionTable";
final String idsessionColumn = "id";

class LoginHelper {
  //cria um construtor privado
  static final LoginHelper _instance = LoginHelper.internal();

  factory LoginHelper() => _instance;

  LoginHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "usuario.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $loginTable($idColumn INTEGER PRIMARY KEY AUTOINCREMENT,$emailColumn TEXT, $senhaColumn TEXT)");
      await db.execute(
          "CREATE TABLE $sessionTable($idsessionColumn INTEGER PRIMARY KEY AUTOINCREMENT)");
    });
  }

  Future<Login> saveLogin(Login login) async {
    Database dbLogin = await db;
    login.id = await dbLogin.insert(loginTable, login.toMap());
    return login;
  }

  Future<Login> getLogin(String email, String senha) async {
    Database dbLogin = await db;
    List<Map> maps = await dbLogin.query(loginTable,
        columns: [idColumn, emailColumn, senhaColumn],
        where: "$emailColumn = ? AND $senhaColumn = ?",
        whereArgs: [email, senha]);
    if (maps.length > 0) {
      return Login.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteLogin(int id) async {
    Database dbLogin = await db;
    return await dbLogin
        .delete(loginTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateLogin(Login login) async {
    Database dbLogin = await db;
    return await dbLogin.update(loginTable, login.toMap(),
        where: "$idColumn = ?", whereArgs: [login.id]);
  }

  Future<List> getAllLogins() async {
    Database dbLogin = await db;
    List listMap = await dbLogin.rawQuery("SELECT * FROM $loginTable");
    List<Login> listPerson = List();
    for (Map m in listMap) {
      listPerson.add(Login.fromMap(m));
    }
    return listPerson;
  }

  //valida session
  Future<bool> getSesseion() async {
    Database dbSesseion = await db;
    List<Map> maps = await dbSesseion.rawQuery("SELECT * FROM $sessionTable");
    print(maps.toString());
    if (maps.toString() != '[]') {
      return true;
    } else {
      return false;
    }
  }

//salvar session
  Future<Session> saveSession(Session session) async {
    Database dbSesseion = await db;
    session.id = await dbSesseion.insert(sessionTable, session.toMap());
    return session;
  }

//deletar session
  Future<int> deleteSession() async {
    Database dbSesseion = await db;
    return await dbSesseion.delete(sessionTable);
  }

  Future close() async {
    Database dbPerson = await db;
    dbPerson.close();
  }
}

class Login {
  int id;
  String email;
  String senha;

  Login();

  //converte os dados de um mapa para dados do objeto atual
  Login.fromMap(Map map) {
    id = map[idColumn];
    email = map[emailColumn];
    senha = map[senhaColumn];
  }

  //converte os dados do objeto atual para um mapa
  Map toMap() {
    Map<String, dynamic> map = {
      emailColumn: email,
      senhaColumn: senha,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Login(id: $id,email: $email, senha: $senha)";
  }
}

class Session {
  int id;

  Session();

  Session.fromMap(Map map) {
    id = map[idsessionColumn];
  }

  //converte os dados do objeto atual para um mapa
  Map toMap() {
    Map<String, dynamic> map = {idColumn: id};
    return map;
  }
}

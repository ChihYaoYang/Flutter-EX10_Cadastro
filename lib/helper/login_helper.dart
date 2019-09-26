import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String loginTable = "loginTableTable";
//Session table
final String sessionTable = "sessionTable";
final String idvalidateColumn = "idvalidate";
final String iduserColumn = "iduser";

final String idColumn = "id";
final String nomeColumn = "nome";
final String emailColumn = "email";
final String senhaColumn = "senha";

class LoginHelper {
  //cria um construtor privado
  static final LoginHelper _instance = LoginHelper.internal();

  //retorna uma instância da classe já executada, sem criar uma nova necessariamente. Ex: quando você vai criar um novo carro, não necessariamente você precisa montar uma fábrica totalmente nova.
  factory LoginHelper() => _instance;

  //inicializa uma instancia interna da própria classe
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
    final path = join(databasesPath, "person.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $loginTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $emailColumn TEXT, $senhaColumn TEXT)"
          "CREATE TABLE $sessionTable($idvalidateColumn INTEGER PRIMARY KEY, $iduserColumn INTEGER)");
    });
  }

  Future<Login> saveLogin(Login login) async {
    Database dbPerson = await db;
    login.id = await dbPerson.insert(loginTable, login.toMap());
    return login;
  }

  //valida session
  Future<bool> session(int id) async {
    Database dbPerson = await db;
    List<Map> maps =
        await dbPerson.query(sessionTable, columns: [iduserColumn]);
    if (maps.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<User> saveSession(User user) async {
    Database dbPerson = await db;
    user.idvalidate = await dbPerson.insert(sessionTable, user.toMap());
    return user;
  }

  Future<Login> getLogins(String email, String senha) async {
    Database dbPerson = await db;
    List<Map> maps = await dbPerson.query(loginTable,
        columns: [emailColumn, senhaColumn],
        where: "$emailColumn = ? and $senhaColumn = ?",
        whereArgs: [email, senha]);
    if (maps.length > 0) {
      return Login.fromMap(maps.first);
    } else {
      return null;
    }
  }


  Future<Login> getLogin(int id) async {
    Database dbPerson = await db;
    List<Map> maps = await dbPerson.query(loginTable,
        columns: [idColumn, nomeColumn, emailColumn, senhaColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Login.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteLogin(int id) async {
    Database dbPerson = await db;
    return await dbPerson
        .delete(loginTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateLogin(Login login) async {
    Database dbPerson = await db;
    return await dbPerson.update(loginTable, login.toMap(),
        where: "$idColumn = ?", whereArgs: [login.id]);
  }

  Future<List> getAllLogins() async {
    Database dbPerson = await db;
    List listMap = await dbPerson.rawQuery("SELECT * FROM $loginTable");
    List<Login> listPerson = List();
    for (Map m in listMap) {
      listPerson.add(Login.fromMap(m));
    }
    return listPerson;
  }

  Future close() async {
    Database dbPerson = await db;
    dbPerson.close();
  }
}

class Login {
  //cria uma nova classe Contact com os campos desejados;
  int id;
  String nome;
  String email;
  String senha;

  //construtor sem parâmetros
  //inicializa a própria classe sem parâmetros;
  Login();

  //converte os dados de um mapa para dados do objeto atual
  Login.fromMap(Map map) {
    id = map[idvalidateColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    senha = map[senhaColumn];
  }

  //converte os dados do objeto atual para um mapa
  Map toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
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
    return "Login(id: $id, nome: $nome, email: $email, senha: $senha)";
  }
}

class User {
  //cria uma nova classe Contact com os campos desejados;
  int idvalidate;
  int iduser;

  //construtor sem parâmetros
  //inicializa a própria classe sem parâmetros;
  User();

  //converte os dados de um mapa para dados do objeto atual
  User.fromMap(Map map) {
    idvalidate = map[idvalidateColumn];
    iduser = map[iduserColumn];
  }

  //converte os dados do objeto atual para um mapa
  Map toMap() {
    Map<String, dynamic> map = {iduserColumn: iduser};
    if (idvalidate != null) {
      map[idvalidateColumn] = idvalidate;
    }
    return map;
  }
}

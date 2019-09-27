import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//define nome e colunas da tabela local
final String personTable = "personTable";
final String idColumn = "id";
final String nomeColumn = "nome";
final String telefoneColumn = "telefone";

class PersonHelper {
  //cria um construtor privado
  static final PersonHelper _instance = PersonHelper.internal();

  //retorna uma instância da classe já executada, sem criar uma nova necessariamente.
  // Ex: quando você vai criar um novo carro, não necessariamente você precisa montar uma fábrica totalmente nova.
  factory PersonHelper() => _instance;

  //inicializa uma instância interna da própria classe
  PersonHelper.internal();

  Database _db;

  Future<Database> get db async {
    //testa se o banco de dados está aberto
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    //resgata o caminho do aplicativo
    final databasesPath = await getDatabasesPath();
    //monta o caminho do arquivo de banco de dados;
    final path = join(databasesPath, "person.db");

    //abre o banco de dados;
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      //executa a query de criação da tabela;
      await db.execute(
          "CREATE TABLE $personTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $telefoneColumn TEXT)");
    });
  }

  Future<Person> savePerson(Person person) async {
    Database dbPerson = await db;
    //salva o person na tabela;
    person.id = await dbPerson.insert(personTable, person.toMap());
    return person;
  }

  Future<Person> getPerson(int id) async {
    Database dbPerson = await db;
    //busca um person na tabela passando um ID como parâmetro
    List<Map> maps = await dbPerson.query(personTable,
        columns: [idColumn, nomeColumn, telefoneColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      //adiciona na classe o person encontrado transformando em uma mapa de objetos
      return Person.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletePerson(int id) async {
    Database dbPerson = await db;
    //deleta um person na tabela;
    return await dbPerson
        .delete(personTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updatePerson(Person person) async {
    Database dbPerson = await db;
    //atualiza um contato na tabela;
    return await dbPerson.update(personTable, person.toMap(),
        where: "$idColumn = ?", whereArgs: [person.id]);
  }

  Future<List> getAllPersons() async {
    Database dbPerson = await db;
    //busca todos os contatos na tabela
    List listMap = await dbPerson.rawQuery("SELECT * FROM $personTable");
    List<Person> listPerson = List();
    for (Map m in listMap) {
      listPerson.add(Person.fromMap(m));
    }
    return listPerson;
  }

  Future close() async {
    Database dbPerson = await db;
    //fecha o banco de dados e libera a memória
    dbPerson.close();
  }
}

class Person {
  //cria uma nova classe Person com os campos desejados;
  int id;
  String nome;
  String telefone;

//construtor sem parâmetros
  Person(); ////inicializa a própria classe sem parâmetros;

  //converte os dados de um mapa para dados do objeto atual
  Person.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    telefone = map[telefoneColumn];
  }

  //converte os dados do objeto atual para um mapa
  Map toMap() {
    Map<String, dynamic> map = {nomeColumn: nome, telefoneColumn: telefone};
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Person(id: $id, name: $nome, telefone: $telefone)";
  }
}

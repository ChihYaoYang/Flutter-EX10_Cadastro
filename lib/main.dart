import 'package:cadastro_app/ui/People.dart';
import 'package:cadastro_app/ui/cadastropage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cadastro_app/helper/person_helper.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Chama Helper /Cria ListView
  PersonHelper helper = PersonHelper();
  List<Person> persons = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contato"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        //Criar ListView
        child: ListView.builder(
            // Criar Lista
            padding: EdgeInsets.all(10.0),
            //Count quanto item tem no DB
            itemCount: persons.length,
            itemBuilder: (context, index) {
              return _itemList(context, index); // return item do DB
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCadastroPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  //初始化狀態時
  @override
  void initState() {
    //Fazer getAll do Item
    super.initState();
    _getAllPersons();
  }

  //Fazer getAll do Item
  void _getAllPersons() {
    helper.getAllPersons().then((list) {
      setState(() {
        persons = list;
      });
    });
  }

  //Ir para Cadastro (INSERT)
  //Passa Class person para cadastropage.dart
  void _showCadastroPage({Person person}) async {
    final recPerson = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroPage(
                  person: person,
                )));
    //Valida person
    if (recPerson != null) {
      //Se for diferente que NULL => UPDATE
      if (person != null) {
        await helper.updatePerson(recPerson);
      } else {
        //Se for null person vazio => INSERT começa nova cadastro
        await helper.savePerson(recPerson);
      }
      _getAllPersons();
    }
  }

  //ListView.builder Montar estrutura da listcard
  Widget _itemList(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(persons[index].nome),
          subtitle: Text(persons[index].telefone),
          onTap: () {
            _showOptions(context, index);
          },
        ),
      ),
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.person, color: Colors.cyan),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Ver',
                                      style: TextStyle(
                                          color: Colors.cyan, fontSize: 20.0),
                                    )
                                  ],
                                ))
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => People(
                                    persons[index].id,
                                    persons[index].nome,
                                    persons[index].telefone)),
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.phone_in_talk, color: Colors.cyan),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Discar',
                                    style: TextStyle(
                                        color: Colors.cyan, fontSize: 20.0),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      onPressed: () {
                        launch("tel:${persons[index].telefone}");
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.edit, color: Colors.cyan),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Editar',
                                    style: TextStyle(
                                        color: Colors.cyan, fontSize: 20.0),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showCadastroPage(person: persons[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.delete, color: Colors.cyan),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Deletar',
                                    style: TextStyle(
                                        color: Colors.cyan, fontSize: 20.0),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      onPressed: () {
                        helper.deletePerson(persons[index].id);
                        setState(() {
                          persons.removeAt(index);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

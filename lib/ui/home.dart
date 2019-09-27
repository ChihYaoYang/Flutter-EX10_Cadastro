import 'package:cadastro_app/ui/People.dart';
import 'package:cadastro_app/ui/cadastropage.dart';
import 'package:cadastro_app/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cadastro_app/helper/person_helper.dart';
import 'package:cadastro_app/helper/login_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Chama Helper /Cria ListView
  PersonHelper helper = PersonHelper();
  List<Person> persons = List();

  //初始化狀態時
  @override
  void initState() {
    super.initState();
    //Como queríamos remover as sobreposições apenas na splash screen,
    // é necessário fazer uma chamada ao método setEnabledSystemUIOverlays
    // passando como parâmetro o valor SystemUiOverlay.values no initState da
    // classe HomePage (tela seguinte a splash) para que a tela volte ao posicionamento normal.
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //Fazer getAll do Item
    _getAllPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contato"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: persons.length,
            itemBuilder: (context, index) {
              return _itemList(context, index);
            }),
      ),
      drawer: Drawer(
        //Menu
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text("Contact"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/user.png'),
              ),
            ),
            ListTile(
              title: Text('Sair'),
              leading: Icon(
                Icons.exit_to_app,
              ),
              onTap: () async {
                LoginHelper helper = LoginHelper();
                helper.deleteSession();
                Navigator.pop(context);
                await Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
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

  //Fazer getAll do Item
  void _getAllPersons() {
    helper.getAllPersons().then((list) {
      setState(() {
        persons = list;
      });
    });
  }

  void _showCadastroPage({Person person}) async {
    //entra na tela CadastroPage e aguarda ele voltar dela.
    final recPerson = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroPage(
                  person: person,
                )));
    //ao voltar verifica se ela voltou vazia.
    if (recPerson != null) {
      //se o parâmetro contact não estiver vazio, significa que é uma atualização.
      if (person != null) {
        await helper.updatePerson(recPerson);
      } else {
        //caso contrário é uma nova inserção.
        await helper.savePerson(recPerson);
      }
      //atualiza a lista de contatos;
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
    //abre um menu de contexto no rodapé da página
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

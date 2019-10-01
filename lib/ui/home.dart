import 'package:cadastro_app/ui/People.dart';
import 'package:cadastro_app/ui/cadastropage.dart';
import 'package:cadastro_app/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cadastro_app/helper/person_helper.dart';
import 'package:cadastro_app/helper/login_helper.dart';
import 'package:cadastro_app/utils/Dialogs.dart';

class HomePage extends StatefulWidget {
  //Constructor
  int login_id;

  HomePage(this.login_id);

  @override
  _HomePageState createState() => _HomePageState();
}

enum OrderOptions { orderaz, orderza }

class _HomePageState extends State<HomePage> {
  //Chama Helper /Cria ListView
  Dialogs dialog = new Dialogs();
  LoginHelper helperLog = LoginHelper();
  PersonHelper helper = PersonHelper();
  List<Person> person = List();

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
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                    const PopupMenuItem<OrderOptions>(
                      child: Text('Ordenar de A-Z'),
                      value: OrderOptions.orderaz,
                    ),
                    const PopupMenuItem<OrderOptions>(
                      child: Text('Ordenar de Z-A'),
                      value: OrderOptions.orderza,
                    ),
                  ],
              onSelected: _orderList)
        ],
      ),
      body: WillPopScope(
          child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: person.length,
              itemBuilder: (context, index) {
                return _itemList(context, index);
              }),
          onWillPop: () {
            return null;
          }),
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
                helper.deleteLogado();
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
  void _getAllPersons() async {
    helper.getAllPersons(widget.login_id).then((list) {
      setState(() {
        person = list;
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
        await helper.updatePerson(recPerson, widget.login_id);
      } else {
        //caso contrário é uma nova inserção.
        await helper.savePerson(recPerson, widget.login_id);
      }
      //atualiza a lista de contatos;
      _getAllPersons();
    }
  }

  //ListView.builder Montar estrutura da listcard
  Widget _itemList(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text('Nome: ' + person[index].nome),
              subtitle: Text('Número: ' + person[index].telefone),
              trailing: Text(person[index].id.toString()),
            )),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _orderList(OrderOptions result) async {
    switch (result) {
      case OrderOptions.orderaz:
        person.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        person.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void _showOptions(BuildContext context, int index) {
    List<Widget> botoes = [];
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.phone_in_talk, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Ligar',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        launch("tel:${person[index].telefone}");
        Navigator.pop(context);
      },
    ));
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.person, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Ver',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15.0),
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
              builder: (context) => People(person[index].id, person[index].nome,
                  person[index].telefone)),
        );
      },
    ));
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.edit, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Modificar',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
        _showCadastroPage(person: person[index]);
      },
    ));
    botoes.add(FlatButton(
      child: Row(
        children: <Widget>[
          Icon(Icons.delete, color: Colors.blueAccent),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  Text(
                    'Deletar',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 15.0),
                  )
                ],
              ))
        ],
      ),
      onPressed: () {
        helper.deletePerson(person[index].id);
        setState(() {
          person.removeAt(index);
          Navigator.pop(context);
        });
      },
    ));
    dialog.showBottomOptions(context, botoes);
  }
}

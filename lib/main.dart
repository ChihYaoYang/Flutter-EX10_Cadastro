import 'package:cadastro_app/ui/Person.dart';
import 'package:cadastro_app/ui/cadastropage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
        child: ListView(
          children: <Widget>[
            _itemList(context, 1, 'AAA', '(01) 123456789'),
            _itemList(context, 2, 'BBB', '(02) 987654321'),
            _itemList(context, 3, 'CCC', '(03) 147852369'),
            _itemList(context, 4, 'DDD', '(04) 963852741'),
            _itemList(context, 5, 'EEE', '(05) 951753852'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            //intent
            context,
            MaterialPageRoute(builder: (context) => CadastroPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _itemList(BuildContext context, int id, String nome, String telefone) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(nome),
          subtitle: Text(telefone),
          onTap: () {
            _showOptions(context, id, nome, telefone);
          },
        ),
      ),
    );
  }

  void _showOptions(
      BuildContext context, int id, String nome, String telefone) {
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
                                builder: (context) =>
                                    Person(id, nome, telefone)),
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
                        launch("tel:$telefone");
                        Navigator.pop(context);
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

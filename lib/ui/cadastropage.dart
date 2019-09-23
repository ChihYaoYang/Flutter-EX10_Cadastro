import 'package:flutter/material.dart';
import '../helper/person_helper.dart';
import 'package:validators/validators.dart';

class CadastroPage extends StatefulWidget {
  //constructor
  final Person person;

  CadastroPage({this.person});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  //Declara variável
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  bool condition = false;
  Person _editedPerson;

  @override
  //初始化狀態時
  void initState() {
    super.initState();
    //Quando person for null => começa uma nova cadastro
    if (widget.person == null) {
      _editedPerson = Person();
    } else {
      //Quando tem valor no person => fazer update da lista
      _editedPerson = Person.fromMap(widget.person.toMap());
      _nomeController.text = _editedPerson.nome;
      _telefoneController.text = _editedPerson.telefone;
    }
    //Opacidade botão resert
    _nomeController.addListener(() {
      btnReset();
    });
    _telefoneController.addListener(() {
      btnReset();
    });
  }

//Opacidade botão resert
  void btnReset() {
    setState(() {
      if (_nomeController.text.isNotEmpty ||
          _telefoneController.text.isNotEmpty) {
        condition = true;
      } else {
        condition = false;
      }
    });
  }

//Resert valor do campo e fecha keyboard
  void _resetFields() {
    _nomeController.text = "";
    _telefoneController.text = "";
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //remove o botão da APPBAR
//          automaticallyImplyLeading: false,
        title: Text(_editedPerson.nome ?? 'Novo contato'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: <Widget>[
          Opacity(
              //define a opacidade conforme o preenchimento dos campos.
              opacity: this.condition ? 1.0 : 0.0,
              child: ButtonTheme(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () {
                      //desativa o clique do botão.
                      condition ? _resetFields() : null;
                    },
                    child: Icon(Icons.refresh),
                  )))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  prefix: Icon(Icons.person),
                  labelText: "Digite o Nome",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                controller: _nomeController,
                validator: (value) {
                  //Valida o campo se for vazio return text
                  if (value.isEmpty) {
                    return "Preencher este campo  !";
                  } else {
                    //else passa valor para _editedPerson  => _editedPerson.nome nome do campo
                    setState(() {
                      _editedPerson.nome = value;
                    });
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefix: Icon(Icons.phone),
                  labelText: "Digite o Telefone",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                controller: _telefoneController,
                validator: (value) {
                  //Valida o campo se for vazio return text
                  if (value.isEmpty) {
                    return "Preencher este campo  !";
                  } else {
                    //else passa valor para _editedPerson  => _editedPerson.telefone nome do campo
                    setState(() {
                      _editedPerson.telefone = value;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //Botão flutuante
        onPressed: () {
          //Valida campo
          if (_formkey.currentState.validate()) {
            //Valida campo se é número
            if (isNumeric(_telefoneController.text)) {
              //Deu certo fecha keyboard  e _editedPerson passa para página Home (ListView)
              FocusScope.of(context).requestFocus(new FocusNode());
              Navigator.pop(context, _editedPerson);
            } else {
              //else exibir mensagem
              _showDialog(
                  'Aviso', 'O campo telefone, Preencher somente números !');
            }
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  //Alert Dialog
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

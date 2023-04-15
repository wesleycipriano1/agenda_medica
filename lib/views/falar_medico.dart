import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/mensagem.dart';
import 'package:flutter_application_1/repository/mensagemrepository.dart';

class falar_medico extends StatefulWidget {
  final String id_recebedor;
  const falar_medico({Key? key, required this.id_recebedor}) : super(key: key);

  @override
  _falar_medicoState createState() => _falar_medicoState();
}

class _falar_medicoState extends State<falar_medico> {
  mensagem_repository _mensagem_repository = mensagem_repository();
  List<Mensagem> _mensagens = [];

  String? _idRecebedor;

  @override
  void initState() {
    super.initState();

    _idRecebedor = widget.id_recebedor;
    carregar_mensagens();
  }

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _mensagens.length,
              itemBuilder: (BuildContext context, int index) {
                final message_ = _mensagens[index];
                return Container(
                  alignment: message_.receiverId == _idRecebedor
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: message_.receiverId == _idRecebedor
                            ? Colors.blue
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        message_.message,
                        style: TextStyle(
                          color: message_.receiverId == _idRecebedor
                              ? Colors.white
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Digite uma mensagem...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final text = _textEditingController.text;
                    if (text.isNotEmpty) {
                      _mensagens.add(Mensagem(
                          message: _textEditingController.text,
                          receiverId: _idRecebedor!,
                          senderId: '',
                          timestamp: Timestamp.now()));
                      setState(() {});
                    }
                    _mensagem_repository.enviarMensagem(
                        _textEditingController.text, _idRecebedor!);
                    setState(() {});

                    if (text.isNotEmpty) {
                      setState(() {});
                      _textEditingController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> carregar_mensagens() async {
    print(_idRecebedor);
    List<Mensagem> mensagens = await _mensagem_repository.obterMensagens();

    setState(() {
      _mensagens = mensagens;
    });
  }
}

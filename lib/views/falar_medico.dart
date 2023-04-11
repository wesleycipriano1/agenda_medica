import 'package:flutter/material.dart';
import 'package:flutter_application_1/repository/mensagemrepository.dart';

class Message {
  final String content;
  final bool isSentByMe;

  Message({required this.content, required this.isSentByMe});
}

class falar_medico extends StatefulWidget {
  const falar_medico({Key? key}) : super(key: key);

  @override
  _falar_medicoState createState() => _falar_medicoState();
}

class _falar_medicoState extends State<falar_medico> {
  final List<Message> _messages = [
    Message(content: 'Olá, tudo bem?', isSentByMe: false),
    Message(content: 'Tudo sim, e com você?', isSentByMe: true),
    Message(content: 'Estou bem também, obrigado!', isSentByMe: false),
  ];

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
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _messages[index];
                return Container(
                  alignment: message.isSentByMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            message.isSentByMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: message.isSentByMe ? Colors.white : null,
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
                      setState(() {
                        _messages.add(
                          Message(content: text, isSentByMe: true),
                        );
                      });
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
}

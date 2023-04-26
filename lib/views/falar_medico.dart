import 'dart:async';
import 'package:intl/intl.dart';
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
  late StreamController<List<Mensagem>> _controller;
  String? _idRecebedor;
  List<Mensagem> messages = [];
  List<Mensagem> receivedMessages = [];
  late ScrollController _messagesScrollController = ScrollController();

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messages.clear();
    _idRecebedor = widget.id_recebedor;
    _controller = StreamController<List<Mensagem>>();
    _mensagem_repository
        .obterMensagensStream(_idRecebedor!)
        .listen((mensagens) {
      setState(() {
        receivedMessages.clear();
        receivedMessages = mensagens;

        messages = combineMessages(receivedMessages, messages);
        _messagesScrollController.animateTo(
          _messagesScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          _messagesScrollController
              .jumpTo(_messagesScrollController.position.maxScrollExtent);
        });
      });
    });
  }

  List<Mensagem> combineMessages(
    List<Mensagem> newMessages,
    List<Mensagem> oldMessages,
  ) {
    List<Mensagem> combinedMessages = List<Mensagem>.from(oldMessages);

    for (Mensagem message in newMessages) {
      if (!combinedMessages.any(
        (oldMessage) =>
            oldMessage.message == message.message &&
            oldMessage.receiverId == message.receiverId &&
            oldMessage.timestamp == message.timestamp,
      )) {
        combinedMessages.add(message);
      }
    }
    combinedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return combinedMessages;
  }

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
              controller: _messagesScrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message_ = messages[index];
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message_.message,
                            style: TextStyle(
                              color: message_.receiverId == _idRecebedor
                                  ? Colors.white
                                  : null,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('HH:mm:ss')
                                .format(message_.timestamp.toDate()),
                            style: TextStyle(
                              color: Color.fromARGB(255, 18, 1, 1),
                              fontSize: 15,
                            ),
                          ),
                        ],
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
                  onPressed: () async {
                    final text = _textEditingController.text;
                    if (text.isNotEmpty) {
                      final message = Mensagem(
                          message: _textEditingController.text,
                          receiverId: _idRecebedor!,
                          senderId: '',
                          timestamp: Timestamp.now());
                      setState(() {
                        _messagesScrollController.animateTo(
                          _messagesScrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                        );
                      });
                      await _mensagem_repository.enviarMensagem(
                          text, _idRecebedor!);

                      _textEditingController.clear();

                      messages = combineMessages(receivedMessages, messages);
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

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

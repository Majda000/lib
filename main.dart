import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat App",
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Message> _messages = [];

  final TextEditingController _controller = TextEditingController();
  Message? _replyingTo;

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(Message(text: _controller.text, replyTo: _replyingTo));
        _controller.clear();
        _replyingTo = null;
      });
    }
  }

  void _replyToMessage(Message message) {
    setState(() {
      _replyingTo = message;
      _controller.text = 'Replying to: ${message.text}\n';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mahii App"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessageBubble(
                  message: _messages[index],
                  onReply: _replyToMessage,
                );
              },
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration.collapsed(
                hintText: "Send a message",
              ),
              onSubmitted: (text) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class ChatMessageBubble extends StatelessWidget {
  final Message message;
  final ValueChanged<Message> onReply;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text(message.text[0]),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Mahii",
                  // ignore: deprecated_member_use
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                if (message.replyTo != null)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    color: Colors.grey.shade200,
                    child: Text(
                      'Replying to: ${message.replyTo!.text}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(message.text),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.reply),
            onPressed: () => onReply(message),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final Message? replyTo;

  Message({required this.text, this.replyTo});
}

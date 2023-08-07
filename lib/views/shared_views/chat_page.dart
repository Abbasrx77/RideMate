import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridemate/services/chat_service.dart';
import 'package:ridemate/views/components/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  void sendMessage()async{
    //only send if there is something to send
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserID, _messageController.text);
    //clear the text controller
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverUserEmail),),
      body: Column(
        children: [
          //messages
          Expanded(
              child:_buildMessageList(),
          ),
          //user input
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Customize the border radius
              side: const BorderSide(color: Colors.grey, width: 1.0), // Add a border
            ),
            color: Colors.grey[200], // Set the background color to grey
            margin: const EdgeInsets.symmetric(horizontal: 0,),
            child: _buildMessageInput(),
          ),

          const SizedBox(height: 7,),
        ],
      ),
    );
  }
  //build message list
  Widget _buildMessageList(){
    return StreamBuilder(stream: _chatService.getMessages(widget.receiverUserID, _firebaseAuth.currentUser!.uid,),
        builder: (context,snapshot){
        if(snapshot.hasError){
          return Text("Erreur ${snapshot.error}");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
        },
    );
  }
  //build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;

    //align the messages to the right or left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5,),
            ChatBubble(message: data['message']),
          ],
        ),
      ),
    );
  }
  //build message input
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              keyboardType: TextInputType.multiline, // Allow multiline input
              maxLines: null, // Remove the line limit for the TextField
              decoration: const InputDecoration(
                border: InputBorder.none, // Remove the border around the TextField
                hintText: "Message", // Placeholder text
              ),
            ),
          ),
          //send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.send, size: 40,),
          ),
          //send button
        ],
      ),
    );
  }
}

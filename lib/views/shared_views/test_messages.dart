import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/views/shared_views/chat_page.dart';
import 'dart:convert';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final storage = FlutterSecureStorage();

  List<String> uids = [];

  Future<List<String>> getUidList() async {
    final storage = FlutterSecureStorage();
    String? uidListString = await storage.read(key: 'uid');
    return uidListString == null ? [] : List<String>.from(jsonDecode(uidListString));
  }


  @override
  void initState() {
    super.initState();
    getUidList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
              onPressed: (){
                //Deconnexion
    },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: _buildUserList(),
    );
  }

  //build a user list except for the current logged in user (plus tard, on affichera que l'utilisateur avec qui la reservation est ok
  // en enregistrant son email dans le FSecureStorage et en ne sélectionnant que lui depuis le firestore)
  Widget _buildUserList() {
    return FutureBuilder(
      future: getUidList(), //fetch uid list and wait
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); //or some other widget while waiting
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else if (snapshot.data!.isEmpty) { //If uid list is empty, return specific widget
          return const Text('UID list from secure storage is empty.');
        } else {
          return _buildUserListFromUids(snapshot.data!);
        }
      },
    );
  }

//Following function will only be called if uid list is loaded and not empty.
  Widget _buildUserListFromUids(List<String> uids) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: uids)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Chargement...");
        } else if (snapshot.hasError) {
          return const Text("Erreur");
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        }
      },
    );
  }


  //build individual user list items
//build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    final email = data['email'];
    return ListTile(
      title: Text('$email'),
      onTap: () {
        //pass the clicked user's EMAIL to the chat page
        Navigator.push(
            context,
            NoAnimationMaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverUserEmail: data['email'],
                  receiverUserID: data['uid'],
                ),
                settings: null
            )
        );
      },
    );
  }

}

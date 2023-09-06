import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/views/conducteur/acceuil.dart';
import 'package:ridemate/views/conducteur/profile_page_conducteur.dart';
import 'package:ridemate/views/shared_views/chat_page.dart';
import 'dart:convert';
import 'package:ridemate/views/conducteur/offre_de_trajet.dart';
import 'package:ridemate/views/conducteur/reservation_en_attente.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  final storage = const FlutterSecureStorage();

  List<String> uids = [];

  Future<List<String>> getUidList() async {
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
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(left: deviceWidth * 0.12),
          child: const Text(
            "Mes messages",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: _buildUserList(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => const AcceuilConducteurPageWidget(), settings: null));
              break;
            case 1:
              Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => const OffreDeTrajet(), settings: null));
              break;
            case 2:
              Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => const ReservationObtenue(), settings: null));
              break;
            case 3:
              break;
            case 4:
              Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => const ConducteurProfilePage(), settings: null));
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send,color: Colors.grey,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send_time_extension,color: Colors.grey,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message,color: Colors.black,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.grey,),
            label: '',
          ),
        ],
      ),
    );
  }

  //build a user list except for the current logged in user (plus tard, on affichera que l'utilisateur avec qui la reservation est ok
  // en enregistrant son email dans le FSecureStorage et en ne sélectionnant que lui depuis le firestore)
  Widget _buildUserList() {
    return
      Column(
        children: [
          /*const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                "Mes messages",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),*/
          Expanded(
          child: FutureBuilder(
            future: getUidList(), //fetch uid list and wait
            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); //or some other widget while waiting
              } else if (snapshot.hasError) {
                return const Text('Erreur');
              } else if (snapshot.data!.isEmpty) { //If uid list is empty, return specific widget
                return const Text('Aucun utilisateur');
              } else {
                return
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: _buildUserListFromUids(snapshot.data!),
                    ),
                  );
              }
            },
          ),
    ),
        ],
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
          return const Center(child: CircularProgressIndicator());
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


  //build individual user list items_
//build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    final email = data['email'];
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
          color: Colors.white, // Couleur de fond de la card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Bordure arrondie
            side: const BorderSide(color: Colors.grey), // Bordure grise
          ),
          child: ListTile(
            title: Text(
              '$email',
              style: const TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
            ),
            onTap: () {
              //pass the clicked user's EMAIL to the chat page
              Navigator.push(
                context,
                NoAnimationMaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverUserEmail: data['email'],
                    receiverUserID: data['uid'],
                  ),
                  settings: null,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

}

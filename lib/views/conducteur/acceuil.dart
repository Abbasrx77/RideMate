import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/utilities/succes_dialog.dart';


class AcceuilConducteurPageWidget extends StatefulWidget {
  const AcceuilConducteurPageWidget({super.key});

  @override
  State<AcceuilConducteurPageWidget> createState() => _AcceuilConducteurPageWidgetState();
}

class _AcceuilConducteurPageWidgetState extends State<AcceuilConducteurPageWidget> {
  final storage = const FlutterSecureStorage();
  final apiService = ApiService();

  Future<String> _readVehiculeValue() async {
    final value = await storage.read(key: 'vehicule');
    return value ?? '';
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String dropdownValue2 = '1';

  //TEXT EDITING CONTROLLER
  final TextEditingController _heure_depart = TextEditingController();
  final TextEditingController _date_depart = TextEditingController();
  final TextEditingController _position = TextEditingController();
  final TextEditingController _description = TextEditingController();



  @override
  Widget build(BuildContext context) {

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: deviceWidth * 0.1,// you can increase or decrease the height as you need
            child: Image.asset('assets/main_logo.png'),
          ),
        ),
      ),
      body:
      Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(deviceWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: deviceHeight * 0.05),
                  const Text('Publier un trajet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: deviceHeight * 0.05),
              Form(
                key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _heure_depart,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Veuillez l'heure";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Heure de départ',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.02),
                          TextFormField(
                            controller: _date_depart,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Veuillez la date";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Date de départ',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.02),
                          TextFormField(
                            controller: _position,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Veuillez entrer votre position";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Position Ex: Cotonou,Akpakpa',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: _readVehiculeValue(), // Lecture de la valeur 'vehicule' du Flutter Secure Storage
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.hasData) {
                                return Visibility(
                                  visible: snapshot.data == 'voiture',
                                  child: Column(
                                    children: [
                                      SizedBox(height: deviceHeight * 0.02),
                                      DropdownButtonFormField(
                                        hint: const Text("Nombre de places"),
                                        validator: (value){
                                          if(value == null || value.isEmpty){
                                            return "Faites un choix !";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.blue),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownValue2 = newValue!;
                                          });
                                        },
                                        items: <String>['1', '2', '3', '4']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator(); // Afficher un indicateur de progression pendant la lecture du Storage
                              }
                            },
                          ),

                          SizedBox(height: deviceHeight * 0.02),
                          TextFormField(
                            controller: _description,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Entrez la description";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Description du trajet',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.03),
                          ElevatedButton(
                            onPressed: () async{

                              final heure_depart = _heure_depart.text;
                              final date_depart = _date_depart.text;
                              final position = _position.text;
                              final description = _description.text;
                              final eneam = await storage.read(key: 'eneam') ?? 'test';

                              Map<String,String?> body = {
                                'heure_depart':heure_depart,
                                'date_depart':date_depart,
                                'position':position,
                                'places':dropdownValue2,
                                'description':description,
                                'eneam':eneam
                              };

                              try{

                                if(!_formKey.currentState!.validate()){
                                  await showSuccesDialog(context, "Veuillez suivre les indications");
                                }else{
                                  final response = await apiService.publier('publier_trajet',body: body);
                                  if(response.statusCode == 200){

                                    _heure_depart.text = '';
                                    _date_depart.text = '';
                                    _position.text = '';
                                    _description.text = '';


                                    await showSuccesDialog(context, "Votre offre a été publiée avec succès${response.body}");

                                  }else{
                                    await showSuccesDialog(context, "Oups, une erreur s'est produite à notre niveau${response.body}");
                                  }
                                }

                              }catch(e){
                                await showSuccesDialog(context, "Oups, une erreur s'est produite à notre niveau ${e}");
                              }

                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: deviceWidth * 0.04, horizontal: deviceWidth * 0.13)),
                            ),
                            child: const Text(
                              'Publier',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                    ]
              ),
      ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0, // Indique la page actuelle (0 pour la première icône)
        onTap: (int index) {

        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send,color: Colors.black,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message,color: Colors.black,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.black,),
            label: '',
          ),
        ],
      ),
    );
  }
}

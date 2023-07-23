import 'package:flutter/material.dart';
import 'package:ridemate/api/api_service.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/views/conducteur/choix_position_depart.dart';
import 'package:ridemate/views/conducteur/choix_profil.dart';
import 'package:ridemate/utilities/error_dialog.dart';
import 'package:ridemate/views/passager/choix_position_depart.dart';
import 'dart:convert';
import 'package:ridemate/views/passager/inscription.dart';


class ConnexionPageWidget extends StatefulWidget {
  const ConnexionPageWidget({super.key});

  @override
  State<ConnexionPageWidget> createState() => _ConnexionPageWidgetState();
}

class _ConnexionPageWidgetState extends State<ConnexionPageWidget> {
  final apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  //TEXT EDITING CONTROLLER
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  //REGEX DE VALIDATION EMAIL
  bool isEmailValid(String email) {
    final RegExp regex = RegExp(
        r'^[a-zA-Z/d.a-zA-Z\d_%-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,4}$'
    );
    return regex.hasMatch(email);
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;


    return Scaffold(

      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(deviceWidth * 0.05),
        child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: deviceHeight * 0.1 ,// you can increase or decrease the height as you need
                    child: Image.asset('assets/logo_in_app.png'),
                  ),
                  SizedBox(height: deviceHeight * 0.05),
                  const Text('Connexion', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: deviceHeight * 0.05),
                  TextFormField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Veuillez entrer l'email";
                      }else if(!isEmailValid(value)){
                        return "Email invalide";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
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
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Entrez un mot de passe";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.04),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) => const ChoixProfilPage(), settings: null));
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: "Vous n'avez pas encore de compte?\n",
                            style: TextStyle(color: Colors.black),

                          ),
                          TextSpan(
                            text: 'Inscrivez-vous',
                            style: TextStyle(color: Colors.blue),

                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.03),
                  ElevatedButton(
                    onPressed: () async{
                      //CONNEXION

                      final email = _email.text.toLowerCase();
                      final password = _password.text.toString();


                      Map<String,String> body = {
                        'email':email,
                        'password':password
                      };

                      try{

                        if(!_formKey.currentState!.validate()){
                          await showErrorDialog(context, "Veuillez suivre les indications.");
                        }else{
                          final response = await apiService.connexion(body: body);
                          if(response.statusCode == 200){
                            var data = jsonDecode(response.body);
                            String fonction = data[0];
                            if(fonction == 'conducteur'){

                              Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) => const ChoixPositionDepart(), settings: null));

                            }else if(fonction == 'passager'){
                              Navigator.pushReplacement(context, NoAnimationMaterialPageRoute(builder: (context) => const ChoixPositionDepartPassager(), settings: null));

                            }else if(fonction == 'admin'){
                              //REDIRECTION Admin

                            }

                          }else if(response.statusCode == 401){
                            await showErrorDialog(context, "Identifiants invalides");
                          } else{
                            await showErrorDialog(context, "Oups, une erreur s'est produite à notre niveau, veuillez réessayer plus tard");
                          }
                        }
                      }catch(e) {
                        await showErrorDialog(context, "Oops, une erreur s'est produite à notre niveau, veuillez réessayer plus tard $e");
                      }


                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: deviceWidth * 0.04, horizontal: deviceWidth * 0.13)),
                    ),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

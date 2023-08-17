import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:ridemate/views/passager/profile_page_passager.dart';
import 'package:ridemate/views/passager/reservation_envoyee.dart';
import 'package:ridemate/views/passager/test_messages_passager.dart';
import 'package:ridemate/views/passager/trajets_trouves.dart';

class AcceuilPassager extends StatefulWidget {
  const AcceuilPassager({super.key});

  @override
  State<AcceuilPassager> createState() => _AcceuilPassagerState();
}

class _AcceuilPassagerState extends State<AcceuilPassager> {
  final storage = const FlutterSecureStorage();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _lieuController = TextEditingController();
  final TextEditingController _heureController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  @override

  //fonction pour faire la recherche

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
            height: deviceWidth *
                0.1, // you can increase or decrease the height as you need
            child: Image.asset('assets/main_logo.png'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            height: 330,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FormField(
                        builder: (FormFieldState<String> state) {
                          return GestureDetector(
                            onTap: () async {
                              TimeOfDay? selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (selectedTime != null) {
                                setState(() {
                                  _heureController.text =
                                      selectedTime.format(context);
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Heure de départ',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              isEmpty: _heureController.text.isEmpty,
                              child: Text(
                                _heureController.text.isEmpty
                                    ? ''
                                    : _heureController.text,
                                style: _heureController.text.isEmpty
                                    ? TextStyle(color: Colors.grey)
                                    : TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      FormField(
                        builder: (FormFieldState<String> state) {
                          return GestureDetector(
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2024),
                                locale: const Locale("fr"),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _dateController.text =
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate);
                                });
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Date de départ',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              isEmpty: _dateController.text.isEmpty,
                              child: Text(
                                _dateController.text.isEmpty
                                    ? ''
                                    : _dateController.text,
                                style: _dateController.text.isEmpty
                                    ? TextStyle(color: Colors.grey)
                                    : TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lieuController,
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Entrez un lieu";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Lieu (Ex: Akpakpa,Kpondehou)',
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 85.0),
                        child: ElevatedButton(
                            onPressed: () async {
                              await storage.write(
                                  key: 'heure_depart',
                                  value: _heureController.text);
                              await storage.write(
                                  key: 'date_depart', value: _dateController.text);
                              await storage.write(
                                  key: 'zone', value: _lieuController.text);

                              Navigator.push(
                                  context,
                                  NoAnimationMaterialPageRoute(
                                      builder: (context) =>
                                      const TrajetsTrouvesPassager(),
                                      settings: null));
                            },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          vertical: deviceWidth * 0.04,
                          horizontal: 5.0, // Adjust the horizontal padding to control the button width
                        ),
                        // Add more style properties as needed
                    ),
                    child: Text('Rechercher'),
                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                  context,
                  NoAnimationMaterialPageRoute(
                      builder: (context) => const ReservationEnvoye(),
                      settings: null));
              break;
            case 2:
              //A FAIRE APRES
              Navigator.push(
                  context,
                  NoAnimationMaterialPageRoute(
                      builder: (context) => const MessagesPassager(),
                      settings: null));
              break;
            case 3:
              Navigator.push(
                  context,
                  NoAnimationMaterialPageRoute(
                      builder: (context) => const PassagerProfilPage(),
                      settings: null));
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.send,
              color: Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: Colors.grey,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.grey,
            ),
            label: '',
          ),
        ],
      ),
    );
    ;
  }
}

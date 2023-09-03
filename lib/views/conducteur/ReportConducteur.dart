import 'package:flutter/material.dart';
import 'package:ridemate/utilities/error_dialog.dart';
import 'package:ridemate/utilities/succes_dialog.dart';
import 'package:ridemate/views/conducteur/card_offre_trajet.dart';

class ReportConducteur extends StatefulWidget {
  const ReportConducteur({Key? key}) : super(key: key);

  @override
  _ReportConducteurState createState() => _ReportConducteurState();
}

class _ReportConducteurState extends State<ReportConducteur> {
  final List<String> reportOptions = ['Plantage', 'Erreurs réseau répétitives', 'Ralentissement','Autre'];
  final List<String> selectedOptions = [];
  final TextEditingController _detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reporter un problème",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Quel est le type de problème auquel vous faites face ?"),
              const SizedBox(height: 20),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: reportOptions.map((option) => ChoiceChip(
                  label: Text(option, style: TextStyle(color: selectedOptions.contains(option) ? Colors.white : Colors.blue)),
                  selected: selectedOptions.contains(option),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                    });
                  },
                  selectedColor: Colors.blue,
                  backgroundColor: selectedOptions.contains(option) ? Colors.blue : Colors.white,
                )).toList(),
              ),
              const SizedBox(height: 20),
              const Text("Donnez nous plus de détails"),
              const SizedBox(height: 10),
              TextFormField(
                controller: _detailsController,
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Entrez les détails ici',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () async{
                        Map<String, String> body = {
                          'type_erreur': selectedOptions.toString(),
                          'informations': _detailsController.text,
                        };
                        if(selectedOptions.isEmpty && _detailsController.text.trim().isEmpty ){
                          await showErrorDialog(context,"Veuillez sélectionner une option");
                        }else{
                          final response = await apiService.reporter(body: body);
                          if(response.statusCode == 200){
                            await showSuccesDialog(context, "Problème reporté avec succès");
                          }else{
                            await showErrorDialog(context, "Oups, une erreur s'est produite à notre niveau, veuillez réessayer plus tard");
                          }
                        }
                      },
                      child: const Text('Reporter'),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

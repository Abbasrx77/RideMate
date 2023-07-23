import 'package:flutter/material.dart';
import 'package:ridemate/utilities/navigation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChoixPositionDepartPassager extends StatelessWidget {
  const ChoixPositionDepartPassager({super.key});
  final storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SizedBox(
          height: deviceWidth * 0.1,// you can increase or decrease the height as you need
          child: Image.asset('assets/main_logo.png'),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/maps.png"),
                    fit: BoxFit.fill)
            ),
          ),
          Positioned(
            width: deviceWidth * 0.6,
            height: deviceHeight * 0.06,
            bottom: deviceHeight * 0.05,
            child: ElevatedButton(
              onPressed: ()async{
                //await storage.write(key: 'eneam', value: "quitter_eneam");
                //Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => const AcceuilConducteurPageWidget(), settings: null));
              },
              child: const Text("Quitter Eneam"),
            ),
          ),
          Positioned(
            width: deviceWidth * 0.6,
            height: deviceHeight * 0.06,
            bottom: deviceHeight * 0.17,
            child: ElevatedButton(
              onPressed: ()async{
                //await storage.write(key: 'eneam', value: "aller_eneam");
                //Navigator.push(context, NoAnimationMaterialPageRoute(builder: (context) => const AcceuilConducteurPageWidget(), settings: null));
              },
              child: const Text("Aller à Eneam"),
            ),
          ),
        ],
      ),
    );
  }
}

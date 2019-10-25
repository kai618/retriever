import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'server.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retriever',
      theme: ThemeData(primarySwatch: Colors.indigo, buttonColor: Colors.indigo),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isValid = false;

  TextEditingController ssidController;
  TextEditingController pwController;

  Server server = Server();

  @override
  void initState() {
    pwController = TextEditingController();
    ssidController = TextEditingController()
      ..addListener(() {
        if (ssidController.text.isEmpty)
          setState(() => isValid = false);
        else
          setState(() => isValid = true);
      });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startServer() {
    server.start(ssidController.text, pwController.text, () {
      setState(() {});
    });
  }

  void closeServer() {
    server.close(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        buildAppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    buildTextField(ssidController, 'SSID'),
                    buildTextField(pwController, 'Password'),
                  ],
                ),
                const SizedBox(height: 20),
                buildButton(isValid),
                const SizedBox(height: 20),
                buildPulseArea(height * 0.5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(title: Text('Retriever'));
  }

  Widget buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: TextField(
        controller: controller,
        readOnly: server.isOn,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }

  Widget buildButton(bool visible) {
    return Visibility(
      visible: visible,
      child: RaisedButton(
        elevation: 5,
        onPressed: server.isOn ? closeServer : startServer,
        child: Text(
          server.isOn ? 'OFF' : 'ON',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget buildPulseArea(double height) {
    return Visibility(
      visible: server.isOn,
      child: SpinKitRipple(size: height, color: Colors.indigo),
    );
  }
}

import 'package:flutter/material.dart';
// import 'package:location/pages/home.dart';
import 'location_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Location Widget Demo'),
        ),
        body: LocationWidget(),
      ),
    );
  }
}

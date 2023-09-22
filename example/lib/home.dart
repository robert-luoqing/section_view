import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/SimpleSectionList");
                },
                child: const Text("Simple Section List")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/CountryList");
                },
                child: const Text("Country List")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/CountryListWithSearch");
                },
                child: const Text("Country List with Search and Alphabet")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/FullSectionList");
                },
                child: const Text("Full Section List")),
                 ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/sectionControllerView");
                },
                child: const Text("Country List with controller")),
          ],
        ),
      ),
    );
  }
}

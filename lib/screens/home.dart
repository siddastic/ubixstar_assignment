import 'package:flutter/material.dart';
import 'package:ubixstar/constants/colors.dart';
import 'package:ubixstar/constants/widgets.dart';
import 'package:ubixstar/screens/add_widget_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AddableWidgets> addedWidgets = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment App"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: ConstantColors.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: addedWidgets.isEmpty
                  ? const Center(
                      child: Text(
                        "No widget is added",
                        textScaleFactor: 1.5,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var w in addedWidgets)
                          if (w == AddableWidgets.Button)
                            ElevatedButton(
                              onPressed: () async {
                                if (addedWidgets.length == 1) {
                                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Atleast add a widget to save"),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: ConstantColors.cardColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  color: ConstantColors.green,
                                ),
                                textScaleFactor: 1.3,
                              ),
                            )
                          else if (w == AddableWidgets.Image)
                            Card(
                              child: Container(
                                width: 200,
                                height: 200,
                                child: Text(
                                  "Upload Image",
                                  textScaleFactor: 1.25,
                                  style: TextStyle(
                                    color: ConstantColors.green,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddWidgetScreen(),
                ),
              );
              if (result != null) {
                setState(() {
                  addedWidgets = result;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              primary: ConstantColors.cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              "Add widgets",
              style: TextStyle(
                color: ConstantColors.green,
              ),
              textScaleFactor: 1.3,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

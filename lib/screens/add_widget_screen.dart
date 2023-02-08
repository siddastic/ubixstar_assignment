import 'package:flutter/material.dart';
import 'package:ubixstar/constants/colors.dart';
import 'package:ubixstar/constants/widgets.dart';
import 'package:ubixstar/widgets/addable_widget.dart';

class AddWidgetScreen extends StatefulWidget {
  const AddWidgetScreen({super.key});

  @override
  State<AddWidgetScreen> createState() => _AddWidgetScreenState();
}

class _AddWidgetScreenState extends State<AddWidgetScreen> {
  List<AddableWidgets> addableWidgets = [];

  void toggleElement(AddableWidgets w) {
    if (addableWidgets.contains(w)) {
      addableWidgets.remove(w);
    } else {
      addableWidgets.add(w);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.cardColor,
      appBar: AppBar(
        title: const Text("Add Widgets"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AddableWidget(
                label: "Text",
                isSelected: addableWidgets.contains(AddableWidgets.Text),
                onClick: () {
                  toggleElement(AddableWidgets.Text);
                },
              ),
              SizedBox(
                height: 30,
              ),
              AddableWidget(
                label: "Image",
                isSelected: addableWidgets.contains(AddableWidgets.Image),
                onClick: () {
                  toggleElement(AddableWidgets.Image);
                },
              ),
              SizedBox(
                height: 30,
              ),
              AddableWidget(
                label: "Button",
                isSelected: addableWidgets.contains(AddableWidgets.Button),
                onClick: () {
                  toggleElement(AddableWidgets.Button);
                },
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(addableWidgets);
              },
              style: ElevatedButton.styleFrom(
                primary: ConstantColors.cardColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                "Import widgets",
                style: TextStyle(
                  color: ConstantColors.green,
                ),
                textScaleFactor: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

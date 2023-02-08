import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ubixstar/constants/colors.dart';
import 'package:ubixstar/constants/widgets.dart';
import 'package:ubixstar/screens/add_widget_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController inputController = TextEditingController();
  List<AddableWidgets> addedWidgets = [];
  XFile? pickedImage;
  bool processing = true;
  String? networkImageUrl;
  List<Map<String, dynamic>> dataToUpload = [];

  @override
  void initState() {
    loadPreviouslyAddedWidgets();
    super.initState();
  }

  void saveData() async {
    dataToUpload.clear();
    setState(() {
      processing = true;
    });
    if (addedWidgets.contains(AddableWidgets.Text)) {
      dataToUpload.add({
        "widget": "text",
        "value": inputController.text.trim(),
      });
    }
    if (addedWidgets.contains(AddableWidgets.Image) && pickedImage != null) {
      await FirebaseStorage.instance
          .ref("ubixstar")
          .putFile(File(pickedImage!.path));
      var downloadUrl =
          await FirebaseStorage.instance.ref("ubixstar").getDownloadURL();
      dataToUpload.add({
        "widget": "image",
        "value": downloadUrl,
      });
    }
    await FirebaseFirestore.instance
        .collection("ubixstar")
        .doc('saved_widgets')
        .set(
            {
          'widgets': dataToUpload,
        },
            SetOptions(
              merge: false,
            ));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data Saved"),
      ),
    );
    setState(() {
      processing = false;
    });
  }

  void loadPreviouslyAddedWidgets() async {
    var doc = await FirebaseFirestore.instance
        .collection("ubixstar")
        .doc('saved_widgets')
        .get();
    var data = doc.data();
    if(data!=null){
      for(var w in data['widgets']){
        if(w['widget'] == "text"){
          addedWidgets.add(AddableWidgets.Text);
          inputController.text = w['value'];
        }
        if(w['widget'] == "image"){
          addedWidgets.add(AddableWidgets.Image);
          networkImageUrl = w['value'];
        }
      }
      addedWidgets.add(AddableWidgets.Button);
    }
    setState(() {
      processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment App"),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AnimatedOpacity(
            opacity: processing ? 1 : 0,
            duration: Duration(milliseconds: 250),
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              color: ConstantColors.green,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .65,
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
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (addedWidgets.length == 1) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Atleast add a widget to save"),
                                  ),
                                );
                              } else {
                                if (addedWidgets
                                    .contains(AddableWidgets.Text)) {
                                  if (_formKey.currentState!.validate()) {
                                    saveData();
                                  }
                                } else {
                                  saveData();
                                }
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
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.zero,
                            child: InkWell(
                              onTap: () async {
                                pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                setState(() {});
                              },
                              child: Container(
                                width: 250,
                                height: 250,
                                color: ConstantColors.primaryColor,
                                child: pickedImage == null && networkImageUrl == null
                                    ? Center(
                                        child: Text(
                                          "Upload Image",
                                          textScaleFactor: 1.25,
                                          style: TextStyle(
                                            color: ConstantColors.green,
                                          ),
                                        ),
                                      )
                                    : pickedImage != null ? Image.file(
                                        File(pickedImage!.path),
                                        fit: BoxFit.contain,
                                      ) : Image.network(
                                        networkImageUrl!,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                          )
                        else if (w == AddableWidgets.Text)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Enter some text to save";
                                  }
                                  return null;
                                },
                                controller: inputController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                    hintText: "Enter Text",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ConstantColors.green),
                                    )),
                              ),
                            ),
                          ),
                    ],
                  ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AddWidgetScreen(preAddedWidgets: addedWidgets),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                "Add widgets",
                style: TextStyle(
                  color: ConstantColors.green,
                ),
                textScaleFactor: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

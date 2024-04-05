import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final PostRef = FirebaseDatabase.instance.reference().child('Post');
  FirebaseAuth _auth = FirebaseAuth.instance;

  File? _image;
  final picker = ImagePicker();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No Image selected');
      }
    });
  }

  Future getCameraImege() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No Image selected');
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Container(
                height: 120,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        getCameraImege();
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        leading: Icon(Icons.camera),
                        title: Text('Camera'),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        getImageGallery();
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Gallery'),
                      ),
                    )
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Upload Blog'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  dialog(context);
                },
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * 1,
                    child: _image != null
                        ? Image.file(_image!,
                            height: 100, width: 100, fit: BoxFit.fill)
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)),
                            height: 100,
                            width: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter Post Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter Post Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (_image != null) {
                      setState(() {
                        // ShowSpinner = true;
                      });
                      int date = DateTime.now().microsecondsSinceEpoch;
                      Reference ref =
                          FirebaseStorage.instance.ref('blogapp$date');
                      UploadTask uploadTask = ref.putFile(_image!);
                      await uploadTask;
                      var newUrl = await ref.getDownloadURL();
                      final User? user = _auth.currentUser;
                      await PostRef.child('Post List')
                          .child(date.toString())
                          .set({
                        'PID': date.toString(),
                        'PImage': newUrl.toString(),
                        'PTime': date.toString(),
                        'PTitle': titleController.text,
                        'PDescription': descriptionController.text,
                        'UEmail': user!.email,
                        'UId': user.uid,
                      });
                      toastMessage('Post Published');
                      setState(() {
                        // ShowSpinner = false;
                      });
                    } else {
                      toastMessage('Please select an image');
                    }
                  } catch (e) {
                    setState(() {
                      //ShowSpinner = false;
                    });
                    toastMessage(e.toString());
                  }
                },
                child: Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}

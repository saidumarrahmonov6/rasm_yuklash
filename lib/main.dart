import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false,));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  uploadPhoto() async{
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final ImagePicker imagePicker = ImagePicker();
    XFile? xFile;

    PermissionStatus permissionStatus = await Permission.photos.request();
    if(permissionStatus.isGranted){
      try {
        xFile = await imagePicker.pickImage(source: ImageSource.gallery);
        File file = File(xFile?.path??"");
        var snapshot = firebaseStorage.ref("images").child("${file.path.split("/").last}").putFile(file).then((value) {
          if(value.state == TaskState.success){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
          }
        });
      } catch(e){
        print(e.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Upload Photo"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: (){
            uploadPhoto();
          },
          child: Text("Upload Photo"),
        ),
      ),
    );
  }
}


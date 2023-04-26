import 'dart:io';

import 'package:budgeto/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController with ChangeNotifier {
  DatabaseReference dbref = FirebaseDatabase.instance.ref().child('Users');
  FirebaseStorage storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser!;

  final picker = ImagePicker();

  XFile? _image;
  XFile? get image => _image;

  Future pickGalleryImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage();
      notifyListeners();
    }
  }

  Future pickCameraImage(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage();
      notifyListeners();
    }
  }

  void pickImage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pickCameraImage(context);
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.camera,
                      color: kGreenColor,
                    ),
                    title: const Text('Camera'),
                  ),
                  ListTile(
                    onTap: () {
                      pickGalleryImage(context);
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.image,
                      color: kGreenColor,
                    ),
                    title: const Text('Gallery'),
                  )
                ],
              ),
            ),
          );
        });
  }

  void uploadImage() async {
    Reference ref = storage.ref('/profileImage${user.uid}');
    UploadTask uploadTask = ref.putFile(File(_image!.path));

    await Future.value(uploadTask);
    final newUrl = await ref.getDownloadURL();

    dbref
        .child(user.uid)
        .update({'profilePic': newUrl.toString()}).then((value) {});
  }
}

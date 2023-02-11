import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class Updateclass extends StatefulWidget {
  String courseid;
  String coursename;
  String coursefee;
  String img;

  Updateclass(this.courseid, this.coursename, this.coursefee, this.img);

  @override
  State<Updateclass> createState() => _UpdateclassState();
}

class _UpdateclassState extends State<Updateclass> {
  XFile? imagepicker;
  String? _imageurl;

  imagecap() async {
    ImagePicker _picker = ImagePicker();
    imagepicker = await _picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  TextEditingController _coursename = TextEditingController();
  TextEditingController _addname = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  Updatedata(id) async {
    if (_imageurl == null) {
      CollectionReference _course =
          await FirebaseFirestore.instance.collection('man');
      _course.add(({
        'name': _coursename.text,
        'course_fee': _addname.text,
        'image_url': widget.img
      }));
    } else {
      File _file = File(imagepicker!.path);
      FirebaseStorage _firestone = await FirebaseStorage.instance;
      UploadTask _uploadTask =
          _firestone.ref('man').child(imagepicker!.name).putFile(_file);

      TaskSnapshot _snapshot = await _uploadTask;
      _imageurl = await _snapshot.ref.getDownloadURL();
      CollectionReference _course =
          await FirebaseFirestore.instance.collection('man');
      _course.add(({
        'name': _coursename.text,
        'course_fee': _addname.text,
        'image_url': _imageurl
      }));
    }

    _addname.clear();
    _coursename.clear();
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _coursename.text = widget.coursename;
    _addname.text = widget.coursefee;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      color: Colors.red.shade200,
      child: Form(
        key: _key,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Filed is enpty";
                  }
                  if (value.length <= 2) {
                    return "Course name is invalid";
                  }
                  if (value.length > 25) {
                    return "Course name is invalid";
                  }
                },
                controller: _coursename,
                decoration: InputDecoration(
                  hintText: "Course Name",
                  prefixIcon: Icon(Icons.person),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Course Fee field is empty";
                  }
                  if (value.length <= 2) {
                    return "Incorrect fee";
                  }
                  if (value.length >= 7) {
                    return "Price too high";
                  }
                },
                controller: _addname,
                decoration: InputDecoration(
                  hintText: "Course Fee",
                  prefixIcon: Icon(Icons.attach_money_rounded),
                  prefixIconColor: Colors.greenAccent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Expanded(
                child: imagepicker == null
                    ? Stack(children: [
                        Image.network(widget.img),
                        Positioned(
                            child: IconButton(
                          onPressed: () {
                            imagecap();
                          },
                          icon: Icon(Icons.camera),
                        ))
                      ])
                    : Image.file(
                        File(imagepicker!.path),
                      )),
            ElevatedButton(
                onPressed: () {
                  Updatedata(widget.courseid);

                  print("Courseid--" + widget.courseid);
                },
                child: Text("Update")),
          ],
        ),
      ),
    );
  }
}

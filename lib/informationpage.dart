import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myblog/modelnavagation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myblog/updateclass.dart';

class Informationpage extends StatefulWidget {
  const Informationpage({super.key});

  @override
  State<Informationpage> createState() => _InformationpageState();
}

class _InformationpageState extends State<Informationpage> {
  @override
  Widget build(BuildContext context) {
    Future<void> Deletenode(selectedData) {
      return FirebaseFirestore.instance
          .collection('man')
          .doc(selectedData)
          .delete();
    }

    updatefctn(courseid, cousename, coursefee, img) {
      showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: true,
          context: context,
          builder: ((context) =>
              Updateclass(courseid, cousename, coursefee, img)));
    }

    Stream<QuerySnapshot> _fatchdata =
        FirebaseFirestore.instance.collection('man').snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _fatchdata,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  "Course Fees ",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: true,
                      context: context,
                      builder: ((context) => Modelnavagationdemo()));
                },
                child: Center(child: Icon(Icons.add)),
              ),
              body: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  scrollDirection: Axis.vertical,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Card(
                      color: Colors.red.shade50,
                      child: ListTile(
                          title: Text("${data['name']}"),
                          subtitle: Text("${data['course_fee']} taka"),
                          leading: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(data['image_url'])),
                          trailing: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Deletenode(document.id);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    updatefctn(document.id, data['name'],
                                        data['course_fee'], data['image_url']);
                                    print("document id--" + document.id);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 30,
                                    color: Colors.green.shade300,
                                  ),
                                )
                              ],
                            ),
                          )),
                    );
                  }).toList()),
            ),
          );
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/Models/students.dart';
import 'package:firebase_crud/Screens/addScreen.dart';
import 'package:firebase_crud/Screens/detailScreen.dart';
import 'package:firebase_crud/Screens/updateScreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //For Firebase Conntection table
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('students');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Firebase CRUD',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: _reference.get(),
          builder: (context, snapshot) {
            //Check for Error
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            }
            //if data received
            else if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              //Convert data to List
              List<Student> students = documents
                  .map((e) => Student(
                      id: e['id'],
                      rollno: e['rollno'],
                      name: e['name'],
                      marks: e['marks']))
                  .toList();
              print("$students");
              return _myGetBody(students);
            } else {
              //Show Loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          // child: _myGetBody(students),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            //TODO: Goto Add Student Page
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddScreen()));
          }),
          child: const Icon(Icons.add),
        ));
  }

  //This For Body

  Widget _myGetBody(students) {
    return students.isEmpty
        ? const Center(
            child: Text('No Student Yet\nClick + to start adding',
                textAlign: TextAlign.center),
          )
        : ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) => Card(
                  color: students[index].marks < 33
                      ? Colors.red.shade100
                      : students[index].marks < 65
                          ? Colors.amberAccent.shade100
                          : Colors.green.shade100,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(student: students[index])));
                    },
                    title: Text(students[index].name),
                    subtitle: Text('Rollno : ${students[index].rollno}'),
                    leading: CircleAvatar(
                      radius: 25,
                      child: Text('${students[index].marks}'),
                    ),
                    trailing: SizedBox(
                      width: 60,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UpdateScreen(
                                          student: students[index])));
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.black.withOpacity(0.75),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              //Delete
                              _reference.doc(students[index].id).delete();

                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red.withOpacity(0.75),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
  }
}

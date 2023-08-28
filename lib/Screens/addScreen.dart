import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/Models/students.dart';
import 'package:firebase_crud/Screens/home.dart';
import 'package:firebase_crud/Widgets/myTextField.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController rollController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController marksController = TextEditingController();
  final FocusNode focusNode = FocusNode();

   @override
  void dispose() {
    rollController.dispose();
    nameController.dispose();
    marksController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text('Add Student',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            myTextField(
                focusNode: focusNode,
                hintText: 'Rollno',
                textInputType: TextInputType.number,
                controller: rollController),
            myTextField(hintText: 'Name', controller: nameController),
            myTextField(
                hintText: 'Marks',
                textInputType: TextInputType.number,
                controller: marksController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      // For Clear
                      rollController.text = '';
                      nameController.text = '';
                      marksController.text = '';
                      focusNode.requestFocus();
                    },
                    child: const Text('Reset',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: () {
                      //For save
                      Student student = Student(
                          rollno: int.parse(rollController.text),
                          name: nameController.text,
                          marks: int.parse(marksController.text));
                      //Add a Student
                      addStudentAndNavigateToHome(student, context);
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  //For Add

  void addStudentAndNavigateToHome(Student student, BuildContext context) {
    //Refreance to firebase
    final studentRef = FirebaseFirestore.instance.collection('students').doc();
    student.id = studentRef.id;
    final data = student.toJson();
    studentRef.set(data).whenComplete(() {
      //
      print('User inserted .');

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
    });
  }
}

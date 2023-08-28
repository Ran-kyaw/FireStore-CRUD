import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/Models/students.dart';
import 'package:firebase_crud/Screens/home.dart';
import 'package:firebase_crud/Widgets/myTextField.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  final Student student;


  UpdateScreen({super.key, required this.student});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
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
    rollController.text = '${widget.student.rollno}';
    nameController.text = widget.student.name;
    marksController.text = '${widget.student.marks}';
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text('Update Student',
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
                      //Update Student
                      Student updateStudent = Student(
                          id: widget.student.id,
                          rollno: int.parse(rollController.text),
                          name: nameController.text,
                          marks: int.parse(marksController.text));

                      //
                      final collectionRefrence =
                          FirebaseFirestore.instance.collection('students');
                      collectionRefrence
                          .doc(updateStudent.id)
                          .update(updateStudent.toJson())
                          .whenComplete(() {
                        //For success
                        print('Student Update Success');
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      });
                    },
                    child: const Text(
                      'Update',
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
}

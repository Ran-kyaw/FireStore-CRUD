import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/Models/students.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Student student;
  DetailsScreen({super.key, required this.student});

  final collectionRefrence = FirebaseFirestore.instance.collection('students');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text('Firebase CRUD',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('${student.rollno}'),
            Text(student.name),
            Text('${student.marks}'),
          ],
        ),
      ),
    );
  }
}

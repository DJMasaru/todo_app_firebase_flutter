import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  const Add({super.key, required this.title});
  final String title;

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  void _addDataAndReturn() {
    final name = nameController.text;
    final age = ageController.text;

    FirebaseFirestore.instance.collection('users').add({
      'name': name,
      'age': age,
    });
    // データを追加した後、画面を閉じる際に新しいデータを受け渡す
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter a name',
                ),
              ),
            ),
            const SizedBox(height: 16.0), // 間隔を設定
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  hintText: 'Enter an age',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addDataAndReturn,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('新規登録'),
            ),
          ],
        ),
      ),
    );
  }
}

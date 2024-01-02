import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.title, required this.documentId});
  final String title;
  final String documentId;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final detailNameController = TextEditingController();
  final detailAgeController = TextEditingController();
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot = await db.collection("users").doc(widget.documentId).get();

    setState(() {
      data = snapshot.data() as Map<String, dynamic>?;
      detailNameController.text = data!['name'];
      detailAgeController.text = data!['age'].toString();
    });
  }

  void _updateData(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      db.collection("users").doc(widget.documentId).update({
        'name': detailNameController.text,
        'age': int.parse(detailAgeController.text),
      });
      Navigator.pop(context, true);
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  void _deleteData(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    try {
      db.collection("users").doc(widget.documentId).delete();
      Navigator.pop(context, true);
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: data != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: detailNameController,
              decoration: const InputDecoration(labelText: '名前'),
            ),
            TextField(
              controller: detailAgeController,
              decoration: const InputDecoration(labelText: '年齢'),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateData(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    fixedSize: const Size(150, 50),
                  ),
                  child: const Text('変更'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteData(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    fixedSize: const Size(150, 50),
                  ),
                  child: const Text('削除'),
                ),

              ],
            ),
          ],
        )
            : const CircularProgressIndicator(), // データ取得中の場合はローディング表示
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'add.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});
  final String title;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Map<String, dynamic>> documentData = [];

  @override
  void initState() {
    super.initState();
    _getDataFromFirebase();
  }

  void _getDataFromFirebase() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("users").get();

    List<Map<String, dynamic>> tempList = [];

    for (var doc in querySnapshot.docs) {
      // ドキュメントのidとデータをマップにしてリストに追加
      tempList.add({
        'id': doc.id,
        'data': doc.data(),
      });
    }

    // 画面を更新
    setState(() {
      documentData = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: documentData.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(documentData[index]['id']),
                subtitle: Text(
                  '名前: ${documentData[index]['data']['name'].toString()},　年齢: ${documentData[index]['data']['age'].toString()}歳',
                ),
                onTap: () async {
                  final deleteResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detail(title:'Detail',documentId: documentData[index]['id']),
                    ),
                  );
                  if (deleteResult == true) {
                    _getDataFromFirebase();
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final addResult = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Add(title: 'Add')),
          );
          if (addResult == true) {
            _getDataFromFirebase();
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

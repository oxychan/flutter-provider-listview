import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_listview/page/editTask.dart';

import '../models/task.dart';
import '../service/tasklist.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({super.key});

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<Tasklist>().fetchTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Listview dengan provider"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: context.watch<Tasklist>().taskList.length,
                itemBuilder: (context, index) {
                  var task = context.watch<Tasklist>().taskList[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        context.read<Tasklist>().deleteTask(task);
                        context.read<Tasklist>().fetchTaskList();
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTaskPage(
                              task: task,
                            ),
                          ),
                        );
                      }
                    },
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue[300],
                      child: Row(
                        children: const [
                          Icon(
                            Icons.inbox_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(
                            context.watch<Tasklist>().taskList[index].name),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // context.read<Tasklist>().addTask();
                      await Navigator.pushNamed(context, "/addTask");
                      // if (!context.mounted) return;
                      if (!mounted) return;
                      context.read<Tasklist>().fetchTaskList();
                    },
                    child: const Text("Halaman Tambah"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:task/models/users.dart';
import 'package:task/models/task.dart';
import 'package:flutter/material.dart';

class taskInfo extends StatelessWidget {
  const taskInfo({super.key});

  @override
  Widget build(BuildContext context) {
  Task tasks = Task();

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Info"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(
                title: Text("Task Name"), subtitle: Text("${tasks.taskName}")),
            ListTile(title: Text("Details"), subtitle: Text("${tasks.details}")),
            ListTile(title: Text("Date"), subtitle: Text("${tasks.date}")),
          ],
        ),
      ),
    );
  }
}

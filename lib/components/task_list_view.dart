import 'package:flutter/material.dart';

import './task_card.dart';
import '../main.dart';
import '../models.dart';

class TaskList extends StatefulWidget {
  final int eventId;
  const TaskList({Key? key, required this.eventId}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  TaskCard Function(BuildContext, int) _itemBuilder(List<Task> tasks) {
    return (BuildContext context, int index) => TaskCard(task: tasks[index]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      key: UniqueKey(),
      stream: objectBox.getTasksOfEvent(widget.eventId),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.hasData ? snapshot.data!.length : 0,
              itemBuilder: _itemBuilder(snapshot.data ?? []));
        } else {
          return const Center(
              child: Text("Pressione '+' para adicionar tarefas"));
        }
      },
    );
  }
}

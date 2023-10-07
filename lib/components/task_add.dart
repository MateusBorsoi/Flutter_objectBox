import 'package:flutter/material.dart';

import '../main.dart';
import '../models.dart';

class AddTask extends StatefulWidget {
  final Event event;
  const AddTask({Key? key, required this.event}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final inputController = TextEditingController();
  final ownerInputController = TextEditingController();
  List<Owner> owners = objectBox.ownerBox.getAll();
  late Owner currentOwner;

  @override
  void initState() {
    currentOwner = owners[0];
    super.initState();
  }

  void updateOwner(int newOwnerId) {
    Owner newCurrentOwner = objectBox.ownerBox.get(newOwnerId)!;

    setState(() {
      currentOwner = newCurrentOwner;
    });
  }

  void createOwner() {
    Owner newOwner = Owner(ownerInputController.text);
    objectBox.ownerBox.put(newOwner);
    List<Owner> newOwnerList = objectBox.ownerBox.getAll();

    setState(() {
      currentOwner = newOwner;
      owners = newOwnerList;
    });
  }

  void createTask() {
    if (inputController.text.isNotEmpty) {
      objectBox.addTask(inputController.text, currentOwner, widget.event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Padding(
            padding: EdgeInsets.only(right: 18),
            child: Text("Adicionar Tarefa")),
      )),
      key: UniqueKey(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: inputController,
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Text("Atribuir dono:", style: TextStyle(fontSize: 17)),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<int>(
                        value: currentOwner.id,
                        items: owners
                            .map((element) => DropdownMenuItem(
                                value: element.id,
                                child: Text(element.name,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        height: 1.0,
                                        overflow: TextOverflow.fade))))
                            .toList(),
                        onChanged: (value) => {updateOwner(value!)},
                        underline: Container(
                          height: 1.5,
                          color: Colors.blueAccent,
                        ),
                      )),
                  const Spacer(),
                  TextButton(
                    onPressed: (() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Novo dono'),
                                content: TextField(
                                  controller: ownerInputController,
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                      hintText: "Informe o nome do dono"),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('Enviar'),
                                    onPressed: () {
                                      createOwner();
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    }),
                    child: const Text(
                      'Adicionar dono',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  child: const Text('Salvar'),
                  onPressed: () {
                    createTask();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

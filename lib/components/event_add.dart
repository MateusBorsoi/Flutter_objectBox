import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

/// Adds a new event
class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final eventNameController = TextEditingController();
  final eventLocationController = TextEditingController();

  DateTime? currentDate;

  void createEvent() {
    if (eventLocationController.text.isNotEmpty &&
        eventNameController.text.isNotEmpty &&
        currentDate != null) {
      objectBox.addEvent(
          eventNameController.text, currentDate!, eventLocationController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar evento"),
      ),
      body: Column(children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: eventNameController,
              decoration: const InputDecoration(
                labelText: 'Nome do evento',
              ),
            )),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: eventLocationController,
              decoration: const InputDecoration(
                labelText: 'Local',
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  currentDate != null
                      ? "Data: ${DateFormat.yMd().format(currentDate!)}"
                      : "Date: Não informada",
                ),
              ),
              const Spacer(),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextButton(
                    child: const Text("Selecione uma data",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2050))
                          .then((date) {
                        setState(() {
                          currentDate = date;
                        });
                      });
                    },
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton(
                  child: const Text(
                    "Salvar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    createEvent();
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ]),
    );
  }
}

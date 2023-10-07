import 'package:flutter/material.dart';

import 'models.dart';
import 'objectbox.g.dart';

/// Provides access to the ObjectBox Store throughout the app.
///
/// Create this in the apps main function.
class ObjectBox {
  late final Store store;

  late final Box<Task> taskBox;
  late final Box<Owner> ownerBox;
  late final Box<Event> eventBox;

  ObjectBox._create(this.store) {
    taskBox = Box<Task>(store);
    ownerBox = Box<Owner>(store);
    eventBox = Box<Event>(store);

    if (eventBox.isEmpty()) {
      _putDemoData();
    }
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }

  void _putDemoData() {
    Event event =
        Event("Teste evento", date: DateTime.now(), location: "Brasil");

    Owner owner1 = Owner('Helena');
    Owner owner2 = Owner('Ana');

    Task task1 = Task('Tarefa atribuida para Helena.');
    task1.owner.target = owner1;

    Task task2 = Task('Tarefa atribuida para Ana.');
    task2.owner.target = owner2;

    event.tasks.add(task1);
    event.tasks.add(task2);

    eventBox.put(event);
  }

  void addTask(String taskText, Owner owner, Event event) {
    Task newTask = Task(taskText);
    newTask.owner.target = owner;

    Event updatedEvent = event;
    updatedEvent.tasks.add(newTask);
    newTask.event.target = updatedEvent;

    eventBox.put(updatedEvent);

    debugPrint(
        "Tarefa adicionada: ${newTask.text} atribuida para ${newTask.owner.target?.name} no evento: ${updatedEvent.name}");
  }

  void addEvent(String name, DateTime date, String location) {
    Event newEvent = Event(name, date: date, location: location);

    eventBox.put(newEvent);
    debugPrint("Evento adicionado: ${newEvent.name}");
  }

  int addOwner(String newOwner) {
    Owner ownerToAdd = Owner(newOwner);
    int newObjectId = ownerBox.put(ownerToAdd);

    return newObjectId;
  }

  Stream<List<Event>> getEvents() {
    final builder = eventBox.query()..order(Event_.date);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  Stream<List<Task>> getTasksOfEvent(int eventId) {
    final builder = taskBox.query()..order(Task_.id, flags: Order.descending);
    builder.link(Task_.event, Event_.id.equals(eventId));
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
}

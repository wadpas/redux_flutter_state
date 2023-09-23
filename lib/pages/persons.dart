import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

const apiUrl = 'http://127.0.0.1:5500/api/people.json';

@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => 'Person ($name, $age years old)';
}

Future<Iterable<Person>> getPerson() => HttpClient()
    .getUrl(Uri.parse(apiUrl))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

@immutable
abstract class Action {
  const Action();
}

@immutable
class LoadPeopleAction extends Action {
  const LoadPeopleAction();
}

@immutable
class SucFetchedPeopleAction extends Action {
  final Iterable<Person> persons;
  const SucFetchedPeopleAction({required this.persons});
}

@immutable
class FailFetchedPeopleAction extends Action {
  final Object error;
  const FailFetchedPeopleAction({required this.error});
}

class PersonsPage extends StatelessWidget {
  const PersonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persons Page'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Button'),
            ),
          )
        ],
      ),
    );
  }
}

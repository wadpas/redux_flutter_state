import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

const apiUrl = 'http://10.0.2.2:5500/api/people.json';

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

@immutable
class State {
  final bool isLoading;
  final Iterable<Person>? fetchedPersons;
  final Object? error;

  const State({
    required this.isLoading,
    required this.fetchedPersons,
    required this.error,
  });

  const State.empty()
      : isLoading = false,
        fetchedPersons = null,
        error = null;
}

State reducer(State oldState, action) {
  if (action is LoadPeopleAction) {
    return const State(
      error: null,
      fetchedPersons: null,
      isLoading: true,
    );
  } else if (action is SucFetchedPeopleAction) {
    return State(
      isLoading: false,
      fetchedPersons: action.persons,
      error: null,
    );
  } else if (action is FailFetchedPeopleAction) {
    return State(
      isLoading: false,
      fetchedPersons: oldState.fetchedPersons,
      error: action.error,
    );
  }
  return oldState;
}

void loadPeopleMiddleware(
  Store<State> store,
  action,
  NextDispatcher next,
) {
  if (action is LoadPeopleAction) {
    getPerson().then((persons) {
      store.dispatch(SucFetchedPeopleAction(persons: persons));
    }).catchError((e) {
      store.dispatch(FailFetchedPeopleAction(error: e));
    });
  }
  next(action);
}

class PersonsPage extends StatelessWidget {
  const PersonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Store(
      reducer,
      initialState: const State.empty(),
      middleware: [loadPeopleMiddleware],
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Persons Page'),
        ),
        body: StoreProvider(
          store: store,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    store.dispatch(const LoadPeopleAction());
                  },
                  child: const Text('Load Persons'),
                ),
                StoreConnector<State, bool>(
                  converter: (store) => store.state.isLoading,
                  builder: (context, isLoading) {
                    if (isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                StoreConnector<State, Iterable<Person>?>(
                  converter: (store) => store.state.fetchedPersons,
                  builder: (context, persons) {
                    if (persons == null) {
                      return const SizedBox();
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: persons.length,
                            itemBuilder: (context, index) {
                              final person = persons.elementAt(index);
                              return ListTile(
                                title: Text(person.name),
                                subtitle: Text('${person.age} years old'),
                              );
                            }),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}

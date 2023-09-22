import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' as hooks;
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

enum ItemFilter {
  all,
  longTexts,
  shortTexts,
}

@immutable
class State {
  final Iterable<String> items;
  final ItemFilter filter;

  const State({
    required this.items,
    required this.filter,
  });

  Iterable<String> get filteredItems {
    switch (filter) {
      case ItemFilter.all:
        return items;
      case ItemFilter.longTexts:
        return items.where((item) => item.length >= 10);
      case ItemFilter.shortTexts:
        return items.where((item) => item.length <= 3);
    }
  }
}

@immutable
class ChangeFilterTypeAction extends Action {
  final ItemFilter filter;
  const ChangeFilterTypeAction(this.filter);
}

@immutable
abstract class ItemAction extends Action {
  final String item;
  const ItemAction(this.item);
}

@immutable
class AddItemAction extends ItemAction {
  const AddItemAction(String item) : super(item);
}

@immutable
class RemoveItemAction extends ItemAction {
  const RemoveItemAction(String item) : super(item);
}

@immutable
abstract class Action {
  const Action();
}

extension AddRemoveItems<T> on Iterable<T> {
  Iterable<T> operator +(T other) => followedBy([other]);
  Iterable<T> operator -(T other) => where((element) => element != other);
}

Iterable<String> addItemReducer(
  Iterable<String> previousItems,
  AddItemAction action,
) =>
    previousItems + action.item;

Iterable<String> removeItemReducer(
  Iterable<String> previousItems,
  RemoveItemAction action,
) =>
    previousItems - action.item;

Reducer<Iterable<String>> itemsReducer = combineReducers<Iterable<String>>([
  TypedReducer<Iterable<String>, AddItemAction>(addItemReducer),
  TypedReducer<Iterable<String>, RemoveItemAction>(removeItemReducer),
]);

ItemFilter itemFilterReducer(
  State oldState,
  Action action,
) {
  if (action is ChangeFilterTypeAction) {
    return action.filter;
  } else {
    return oldState.filter;
  }
}

State appStateReducer(State oldState, action) => State(
      items: itemsReducer(oldState.items, action),
      filter: itemFilterReducer(oldState, action),
    );

class ItemFilterPage extends hooks.HookWidget {
  const ItemFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Store(
      appStateReducer,
      initialState: const State(
        items: [],
        filter: ItemFilter.all,
      ),
    );
    final textController = hooks.useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Filter'),
      ),
      body: StoreProvider(
        store: store,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      store.dispatch(
                        const ChangeFilterTypeAction(ItemFilter.all),
                      );
                    },
                    child: const Text('All'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      store.dispatch(
                        const ChangeFilterTypeAction(ItemFilter.shortTexts),
                      );
                    },
                    child: const Text('Short items'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      store.dispatch(
                        const ChangeFilterTypeAction(ItemFilter.longTexts),
                      );
                    },
                    child: const Text('Long items'),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: textController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final text = textController.text;
                        store.dispatch(AddItemAction(text));
                        textController.clear();
                      },
                      child: const Text('Add'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final text = textController.text;
                        store.dispatch(RemoveItemAction(text));
                        textController.clear();
                      },
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              ),
              StoreConnector<State, Iterable<String>>(
                converter: (store) => store.state.filteredItems,
                builder: (context, items) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items.elementAt(index);
                        return ListTile(title: Text(item));
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

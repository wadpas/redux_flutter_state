import 'package:flutter/material.dart';

enum ItemFilter {
  all,
  longText,
  shortText,
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
      case ItemFilter.longText:
        return items.where((item) => items.length >= 10);
      case ItemFilter.shortText:
        return items.where((item) => items.length <= 3);
    }
  }
}

@immutable
class ChangeFilterTypeAction extends Action {
  final ItemFilter filter;
  const ChangeFilterTypeAction({required this.filter});
}

@immutable
abstract class Action {
  const Action();
}

class ItemFilterPage extends StatelessWidget {
  const ItemFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Filter'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum ItemFilter {
  all,
  longText,
  shortText,
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redux_flutter_state/pages/item_filter.dart';
import 'package:redux_flutter_state/pages/persons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redux Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.mulishTextTheme().copyWith(
          labelLarge: const TextStyle(fontSize: 16),
        ),
      ),
      home: const HomePage(),
      routes: {
        '/item-filter': (context) => const ItemFilterPage(),
        '/persons': (context) => const PersonsPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redux Flutter'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/item-filter');
                },
                child: const Text('Item Filter Page'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/persons');
                },
                child: const Text('Persons Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

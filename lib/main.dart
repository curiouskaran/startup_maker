import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Startup Name genarator",
        theme:
            new ThemeData(primaryColor: Colors.white, accentColor: Colors.lime),
        home: RandomWords());
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<WordPair> _saved = new Set<WordPair>();

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase.replaceAllMapped(new RegExp(r'([A-Z][a-z]+)'),
            (match) {
          return ' ${match.group(0)}';
        }),
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.bookmark : Icons.bookmark_border,
        color: alreadySaved ? Colors.green : null,
      ),
      onTap: () {
        setState(() {
          alreadySaved ? _saved.remove(pair) : _saved.add(pair);
        });
      },
    );
  }

  void _pushSaved() {
    if (_saved.length > 0) {
      Navigator.of(context)
          .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
          return new ListTile(
            title: new Text(
              pair.asPascalCase.replaceAllMapped(new RegExp(r'([A-Z][a-z]+)'),
                  (match) {
                return ' ${match.group(0)}';
              }),
              style: _biggerFont,
            ),
          );
        });
        final List<Widget> divided =
            ListTile.divideTiles(context: context, tiles: tiles).toList();

        return new Scaffold(
          appBar: AppBar(
            title: const Text("Saved Suggestions"),
          ),
          body: new ListView(
            children: divided,
          ),
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

class RandomWords extends StatefulWidget {
  RandomWordsState createState() => new RandomWordsState();
}

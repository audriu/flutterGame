import 'package:flutter/material.dart';
import 'dart:async';

enum Direction {
  left,
  right,
  up,
  down,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Direction _direction = Direction.right;
  final int dimensions = 10;

  List<List<String>>? world;
  int playerX = 0;
  int playerY = 4;

  @override
  void initState() {
    super.initState();
    _resetGame();
    Timer _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      _calculateState();
    });
  }

  void _calculateState() {
    setState(() {
      world![playerY][playerX] = "";
      switch (_direction) {
        case Direction.left:
          playerX--;
          break;
        case Direction.right:
          playerX++;
          break;
        case Direction.up:
          playerY--;
          break;
        case Direction.down:
          playerY++;
          break;
      }
      if (playerX < 0) {
        playerX = dimensions - 1;
      } else if (playerX >= dimensions) {
        playerX = 0;
      }
      if (playerY < 0) {
        playerY = dimensions - 1;
      } else if (playerY >= dimensions) {
        playerY = 0;
      }
      world![playerY][playerX] = "👾";
    });
  }

  void _resetGame() {
    setState(() {
      world =
          List.generate(dimensions, (_) => List<String>.filled(dimensions, ""));
      playerX = 0;
      playerY = 4;
      world![playerY][playerX] = "👾";
      _direction = Direction.right;
    });
  }

  void _setDirection(Direction dir) {
    setState(() {
      _direction = dir;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Text(
            _direction.toString(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          IconButton(
            onPressed: () {
              _setDirection(Direction.left);
            },
            icon: Icon(Icons.arrow_left),
          ),
          IconButton(
            onPressed: () {
              _setDirection(Direction.up);
            },
            icon: Icon(Icons.arrow_upward),
          ),
          IconButton(
            onPressed: () {
              _setDirection(Direction.down);
            },
            icon: Icon(Icons.arrow_downward),
          ),
          IconButton(
            onPressed: () {
              _setDirection(Direction.right);
            },
            icon: Icon(Icons.arrow_right),
          ),
        ],
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: dimensions,
          children: List.generate(dimensions * dimensions, (index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple),
              ),
              child: Center(
                child: Text(
                  world![index ~/ dimensions][index % dimensions],
                  style: TextStyle(fontSize: 32),
                ),
              ),
            );
          }),
        ),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[

      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetGame,
        tooltip: 'Reset',
        child: const Icon(Icons.new_label),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TicTacToePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFancyTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.tealAccent, Colors.cyanAccent, Colors.pinkAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: const Text(
        "Tic Tac Toe",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeIn,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.grid_on, size: 90, color: Colors.tealAccent.shade400),
              const SizedBox(height: 20),
              _buildFancyTitle(),
              const SizedBox(height: 40),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage>
    with SingleTickerProviderStateMixin {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String? winner;
  bool isDraw = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (board[index] == '' && winner == null) {
      setState(() {
        board[index] = currentPlayer;
        _checkWinner();
        if (winner == null && !isDraw) {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  void _checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var pattern in winPatterns) {
      String a = board[pattern[0]];
      String b = board[pattern[1]];
      String c = board[pattern[2]];
      if (a != '' && a == b && b == c) {
        setState(() {
          winner = a;
        });
        _controller.repeat(reverse: true);
        return;
      }
    }

    if (!board.contains('')) {
      setState(() {
        isDraw = true;
      });
    }
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = null;
      isDraw = false;
      _controller.reset();
    });
  }

  Widget _buildPlayerIndicator(String player, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isActive
            ? const LinearGradient(
          colors: [Colors.tealAccent, Colors.cyanAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        border: Border.all(
          color: isActive ? Colors.tealAccent : Colors.white30,
          width: 2,
        ),
        color: isActive ? null : Colors.white.withOpacity(0.05),
        boxShadow: isActive
            ? [
          BoxShadow(
            color: Colors.tealAccent.withOpacity(0.6),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ]
            : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            player == "X" ? "Player One" : "Player Two",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black87 : Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            player,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFancyTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.tealAccent, Colors.cyanAccent, Colors.pinkAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: const Text(
        "Tic Tac Toe",
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _buildFancyTitle(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _resetGame,
        icon: const Icon(Icons.refresh),
        label: const Text("Restart"),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (winner != null || isDraw)
              ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  winner != null ? "$winner Wins 🎉" : "It's a Draw 🤝",
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPlayerIndicator("X", currentPlayer == "X"),
                    _buildPlayerIndicator("O", currentPlayer == "O"),
                  ],
                ),
              ),
            const SizedBox(height: 30),
            GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _handleTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Colors.white30, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        )
                      ],
                    ),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: board[index] == 'X'
                              ? Colors.tealAccent
                              : board[index] == 'O'
                              ? Colors.pinkAccent
                              : Colors.transparent,
                        ),
                        child: Text(board[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

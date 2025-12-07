import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MansionScreen extends StatefulWidget {
  const MansionScreen({super.key});

  @override
  State<MansionScreen> createState() => _MansionScreenState();
}

class _MansionScreenState extends State<MansionScreen> {
  // Grid settings
  final int rows = 10;
  final int cols = 8;
  
  // Game State
  int playerIndex = 0; // Top-left
  int exitIndex = 79; // Bottom-right (rows * cols - 1)
  List<int> ghostIndices = [];
  int lives = 3;
  bool isGameOver = false;
  bool isVictory = false;
  Timer? _gameTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    playerIndex = 0;
    exitIndex = (rows * cols) - 1;
    lives = 3;
    isGameOver = false;
    isVictory = false;
    
    // Spawn 5 ghosts at random locations (not on player)
    ghostIndices = [];
    while (ghostIndices.length < 5) {
      int r = _random.nextInt(rows * cols);
      if (r != playerIndex && r != exitIndex && !ghostIndices.contains(r)) {
        ghostIndices.add(r);
      }
    }

    _startGameLoop();
  }

  void _startGameLoop() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted && !isGameOver && !isVictory) {
        _moveGhosts();
      }
    });
  }

  void _moveGhosts() {
    setState(() {
      for (int i = 0; i < ghostIndices.length; i++) {
        int current = ghostIndices[i];
        List<int> possibleMoves = [];

        // Check Up
        if (current - cols >= 0) possibleMoves.add(current - cols);
        // Check Down
        if (current + cols < rows * cols) possibleMoves.add(current + cols);
        // Check Left
        if (current % cols != 0) possibleMoves.add(current - 1);
        // Check Right
        if ((current + 1) % cols != 0) possibleMoves.add(current + 1);

        // Move towards player with 30% chance, otherwise random
        if (_random.nextDouble() < 0.3) {
           // Simple AI: try to reduce distance
           int pRow = playerIndex ~/ cols;
           int pCol = playerIndex % cols;
           int gRow = current ~/ cols;
           int gCol = current % cols;
           
           possibleMoves.sort((a, b) {
             int aRow = a ~/ cols;
             int aCol = a % cols;
             int bRow = b ~/ cols;
             int bCol = b % cols;
             int distA = (pRow - aRow).abs() + (pCol - aCol).abs();
             int distB = (pRow - bRow).abs() + (pCol - bCol).abs();
             return distA.compareTo(distB);
           });
        }

        if (possibleMoves.isNotEmpty) {
          ghostIndices[i] = possibleMoves[_random.nextInt(possibleMoves.length)];
        }
      }
      _checkCollisions();
    });
  }

  void _movePlayer(String direction) {
    if (isGameOver || isVictory) return;

    setState(() {
      int nextIndex = playerIndex;
      switch (direction) {
        case 'UP':
          if (playerIndex - cols >= 0) nextIndex -= cols;
          break;
        case 'DOWN':
          if (playerIndex + cols < rows * cols) nextIndex += cols;
          break;
        case 'LEFT':
          if (playerIndex % cols != 0) nextIndex -= 1;
          break;
        case 'RIGHT':
          if ((playerIndex + 1) % cols != 0) nextIndex += 1;
          break;
      }
      playerIndex = nextIndex;
      _checkCollisions();
      
      if (playerIndex == exitIndex) {
        isVictory = true;
        _gameTimer?.cancel();
        _showEndDialog(true);
      }
    });
  }

  void _checkCollisions() {
    if (ghostIndices.contains(playerIndex)) {
      lives--;
      // Push ghosts away slightly to give a chance? Or just respawn player?
      // Let's just flash screen red logic (visual handled in build)
      if (lives <= 0) {
        isGameOver = true;
        _gameTimer?.cancel();
        _showEndDialog(false);
      } else {
        // Respawn player at start if hit? Or just lose life?
        // Let's keep position but lose life for intensity
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('AIE ! Un fantôme t\'a touché !'),
            backgroundColor: Colors.red,
            duration: const Duration(milliseconds: 500),
          ),
        );
      }
    }
  }

  void _showEndDialog(bool won) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          won ? 'ÉCHAPPÉ !' : 'MORT...',
          style: TextStyle(color: won ? Colors.green : Colors.red),
        ),
        content: Text(
          won 
            ? 'Tu as survécu au manoir. Tu peux retourner dormir.' 
            : 'Les fantômes t\'ont eu. Ton âme leur appartient.',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to quiz or home
            },
            child: const Text('Quitter'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _initializeGame();
              });
            },
            child: const Text('Rejouer'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: const Text('MANOIR HANTÉ'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.purpleAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                Text(' x$lives', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: rows * cols,
                itemBuilder: (context, index) {
                  bool isPlayer = index == playerIndex;
                  bool isGhost = ghostIndices.contains(index);
                  bool isExit = index == exitIndex;

                  Color cellColor = Colors.grey[850]!;
                  Widget? child;

                  if (isPlayer) {
                    cellColor = Colors.blue[900]!;
                    child: const Center(child: Text('😨', style: TextStyle(fontSize: 24)));
                  } else if (isGhost) {
                    cellColor = Colors.purple[900]!.withOpacity(0.5);
                    child: const Center(child: Text('👻', style: TextStyle(fontSize: 24)));
                  } else if (isExit) {
                    cellColor = Colors.green[900]!;
                    child: const Center(child: Text('🚪', style: TextStyle(fontSize: 24)));
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(4),
                      border: isPlayer ? Border.all(color: Colors.blueAccent) : null,
                    ),
                    child: child,
                  );
                },
              ),
            ),
          ),
          // Controls
          Container(
            height: 180,
            padding: const EdgeInsets.only(bottom: 20),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _movePlayer('UP'),
                  icon: const Icon(Icons.arrow_upward, color: Colors.white, size: 40),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => _movePlayer('LEFT'),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: () => _movePlayer('RIGHT'),
                      icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 40),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _movePlayer('DOWN'),
                  icon: const Icon(Icons.arrow_downward, color: Colors.white, size: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

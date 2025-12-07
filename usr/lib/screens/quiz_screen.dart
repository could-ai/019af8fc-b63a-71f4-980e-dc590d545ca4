import 'dart:math';
import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/quiz_question.dart';
import 'package:couldai_user_app/screens/mansion_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizQuestion _currentQuestion;
  final Random _random = Random();
  int _strikes = 0;
  final int _maxStrikes = 3;

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestion = embarrassingQuestions[_random.nextInt(embarrassingQuestions.length)];
    });
  }

  void _handleRefusal() {
    setState(() {
      _strikes++;
    });

    if (_strikes >= _maxStrikes) {
      _punishUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Attention ! Plus que ${_maxStrikes - _strikes} chances avant le manoir...'),
          backgroundColor: Colors.orange,
        ),
      );
      _nextQuestion();
    }
  }

  void _handleSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('C\'est noté... on garde ça secret (ou pas).'),
        backgroundColor: Colors.green,
      ),
    );
    _nextQuestion();
  }

  void _punishUser() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('TROP LÂCHE !', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text(
          'Tu as refusé de répondre à trop de questions.\n\nTu es maintenant banni dans le MANOIR HANTÉ.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MansionScreen()),
              );
            },
            child: const Text('J\'accepte mon sort', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0000), // Very dark red
      appBar: AppBar(
        title: const Text('VÉRITÉ OU PUNITION'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Erreurs : $_strikes / $_maxStrikes',
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.red, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.psychology_alt, size: 60, color: Colors.white70),
                  const SizedBox(height: 20),
                  Text(
                    _currentQuestion.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Intensité : ${_currentQuestion.intensity}/10',
                    style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleRefusal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('JE REFUSE'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleSuccess,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: const Text('J\'AVOUE'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Si tu refuses 3 fois, tu seras envoyé dans le manoir...',
              style: TextStyle(color: Colors.white30, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

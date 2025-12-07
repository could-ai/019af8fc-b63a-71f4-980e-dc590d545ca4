import 'dart:async';
import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/blackmail.dart';
import 'package:couldai_user_app/screens/penalty_screen.dart';

class ActiveScreen extends StatefulWidget {
  final TimeOfDay targetTime;
  final Blackmail blackmail;

  const ActiveScreen({
    super.key,
    required this.targetTime,
    required this.blackmail,
  });

  @override
  State<ActiveScreen> createState() => _ActiveScreenState();
}

class _ActiveScreenState extends State<ActiveScreen> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;
  bool _isSafe = false;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    DateTime target = DateTime(
      now.year,
      now.month,
      now.day,
      widget.targetTime.hour,
      widget.targetTime.minute,
    );

    // If target is earlier today, assume it's tomorrow (unless it's very close, logic simplified for demo)
    // Actually, for a sleep app, if it's 23:00 and I set 07:00, it's tomorrow.
    // If it's 23:00 and I set 23:30, it's today.
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }

    final diff = target.difference(now);

    if (diff.isNegative) {
      // TIME IS UP!
      _triggerPenalty();
    } else {
      setState(() {
        _timeLeft = diff;
      });
    }
  }

  void _triggerPenalty() {
    _timer.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PenaltyScreen(blackmail: widget.blackmail),
      ),
    );
  }

  void _goToSleep() {
    _timer.cancel();
    setState(() {
      _isSafe = true;
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSafe) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bed, size: 100, color: Colors.greenAccent),
              const SizedBox(height: 20),
              const Text(
                'BONNE NUIT.',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Tu as sauvé ta dignité... pour ce soir.',
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                child: const Text('Retour au menu', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text('COMPTE À REBOURS', style: TextStyle(color: Colors.red)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Dors avant :',
              style: TextStyle(color: Colors.white54, fontSize: 20),
            ),
            Text(
              widget.targetTime.format(context),
              style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'TEMPS RESTANT',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _formatDuration(_timeLeft),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Text(
              'Menace active : ${widget.blackmail.title}',
              style: const TextStyle(color: Colors.redAccent, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Si le compteur atteint 0, ${widget.blackmail.description.toLowerCase()}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400]),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _goToSleep,
                icon: const Icon(Icons.nights_stay),
                label: const Text('JE DORS MAINTENANT !'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

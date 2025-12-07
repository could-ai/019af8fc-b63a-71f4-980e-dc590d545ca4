import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/blackmail.dart';
import 'package:couldai_user_app/screens/active_screen.dart';
import 'package:couldai_user_app/screens/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 23, minute: 0);
  Blackmail? _selectedBlackmail;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.grey[900],
              hourMinuteTextColor: Colors.redAccent,
              dayPeriodTextColor: Colors.white,
              dialHandColor: Colors.redAccent,
              dialBackgroundColor: Colors.grey[800],
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _startSession() {
    if (_selectedBlackmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Choisis une punition d\'abord !'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveScreen(
          targetTime: _selectedTime,
          blackmail: _selectedBlackmail!,
        ),
      ),
    );
  }

  void _startQuizGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SLEEP OR DIE (Virtually)'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- NEW GAME MODE BUTTON ---
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A0000),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purpleAccent, width: 2),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(Icons.games, size: 40, color: Colors.purpleAccent),
                    title: const Text(
                      'MODE JEU : VÉRITÉ OU MANOIR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: const Text(
                      'Réponds aux questions gênantes ou affronte les fantômes...',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.purpleAccent),
                    onTap: _startQuizGame,
                  ),
                ),
                
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                
                const Text(
                  'MODE CLASSIQUE : CHANTAGE SOMMEIL',
                  style: TextStyle(
                    color: Colors.redAccent, 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                const Text(
                  'À quelle heure dois-tu dormir ?',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.redAccent, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54,
                    ),
                    child: Text(
                      _selectedTime.format(context),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontFamily: 'Courier', // Monospaced look
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Choisis ton poison (Conséquence) :',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: blackmailOptions.length,
                  itemBuilder: (context, index) {
                    final option = blackmailOptions[index];
                    final isSelected = _selectedBlackmail?.id == option.id;
                    return Card(
                      color: isSelected ? Colors.redAccent.withOpacity(0.2) : Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: isSelected ? Colors.redAccent : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Text(
                          option.iconEmoji,
                          style: const TextStyle(fontSize: 30),
                        ),
                        title: Text(
                          option.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          option.description,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedBlackmail = option;
                          });
                        },
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Colors.redAccent)
                            : null,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _startSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ACCEPTER LE PACTE',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

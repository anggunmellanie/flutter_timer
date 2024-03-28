import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  Timer? _timer;
  int _totalSeconds = 0;
  int _currentSeconds = 0;
  final TextEditingController _secondController = TextEditingController();
  bool _isTimerRunning = false;

  void _startTimer() {
    if (_currentSeconds <= 0) {
      int minutes = int.tryParse(_secondController.text) ?? 0;
      _currentSeconds = _totalSeconds = minutes * 60;
    }
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        setState(() {
          _currentSeconds--;
        });
      } else {
        _timer?.cancel();
        _showTimerDialog();
      }
    });

    setState(() {
      _isTimerRunning = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _currentSeconds = _totalSeconds = 0;
      _isTimerRunning = false;
      _secondController.clear();
    });
  }

  void _showTimerDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Time's up!"),
        content: const Text("The timer has finished."),
        actions: <Widget>[
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Restart"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog first
              _currentSeconds = _totalSeconds; // Reset the current seconds to the total seconds
              _startTimer(); // Start the timer again
            },
          ),
        ],
      );
    },
  );
}


  @override
  void dispose() {
    _timer?.cancel();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2757),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Timer",
                style: TextStyle(color: Colors.white, fontSize: 28.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _secondController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter minutes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: _totalSeconds > 0 ? _currentSeconds / _totalSeconds : 0,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 6,
                    ),
                  ),
                  Text(
                    '${(_currentSeconds ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white, fontSize: 48.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isTimerRunning ? _stopTimer : _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isTimerRunning ? Colors.red : Colors.green,
                    ),
                    child: Text(
                      _isTimerRunning ? 'Stop' : 'Start',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20), // Space between buttons
                  if (!_isTimerRunning) // Show reset button only when timer is not running
                    ElevatedButton(
                      onPressed: _resetTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

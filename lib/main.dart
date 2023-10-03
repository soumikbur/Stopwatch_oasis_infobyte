import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(StopwatchApp());
}

class StopwatchApp extends StatefulWidget {
  @override
  _StopwatchAppState createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 100), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    if (_stopwatch.isRunning) {
      setState(() {});
    }
  }

  // Start button logic
  void _startTimer() {
    setState(() {
      _stopwatch.start();
      _isRunning = true;
    });
  }

  // Stop button logic
  void _stopTimer() {
    setState(() {
      _stopwatch.stop();
      _isRunning = false;
      _stopwatch.reset(); // Reset the stopwatch when stopping.
    });
  }

  // Hold button logic
  void _holdTimer() {
    setState(() {
      if (_isRunning) {
        _stopwatch.stop();
        _isRunning = false;
      } else {
        _stopwatch.start();
        _isRunning = true;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 24.0, // Change the font size as needed
          ),
          // You can also customize other text styles here
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stopwatch App', style: TextStyle(fontFamily: 'Quicksand')),
          centerTitle: true, // Center the title of the navigation bar
        ),
        backgroundColor: Colors.transparent, // Set the background to transparent
        body: Center(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 350, // Adjust the size as needed
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x4361ee), // Light blue
                        Color(0xFF1976D2), // Dark blue
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 4.0,
                    ),
                  ),
                  child: CustomPaint(
                    painter: ProgressPainter(
                      percentage: _stopwatch.elapsed.inSeconds % 60 / 60, // Calculate the percentage
                      color: Colors.greenAccent, // Color of the progress bar
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            'HR',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            _stopwatch.elapsed.inHours.toString().padLeft(2, '0'),
                            style: TextStyle(fontSize: 48, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: <Widget>[
                          Text(
                            'MIN',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            (_stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0'),
                            style: TextStyle(fontSize: 48, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: <Widget>[
                          Text(
                            'SEC',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0'),
                            style: TextStyle(fontSize: 48, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${(_stopwatch.elapsed.inMilliseconds % 1000).toString().padLeft(3, '0')}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 5,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _isRunning
                          ? ElevatedButton(
                        onPressed: _stopTimer,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Stop', style: TextStyle(fontSize: 20)),
                      )
                          : ElevatedButton(
                        onPressed: _startTimer,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text('Start', style: TextStyle(fontSize: 20)),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _holdTimer,
                        style: ElevatedButton.styleFrom(
                          primary: _isRunning ? Colors.orangeAccent : Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(_isRunning ? 'Hold' : 'Resume', style: TextStyle(fontSize: 20)),
                      ),
                    ],
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

class ProgressPainter extends CustomPainter {
  final double percentage;
  final Color color;

  ProgressPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);

    final double arcAngle = 2 * pi * percentage;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

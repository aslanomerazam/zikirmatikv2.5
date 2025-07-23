import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Zikirmatik(),
    );
  }
}

class Zikirmatik extends StatefulWidget {
  const Zikirmatik({super.key});

  @override
  State<Zikirmatik> createState() => _ZikirmatikState();
}

class _ZikirmatikState extends State<Zikirmatik>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  double _scaleIncrement = 1.0;
  double _scaleReset = 1.0;

  Future<void> _playClickSound() async {
    await _audioPlayer.play(AssetSource('sounds/click.wav'));
  }

  Future<void> _playWrongSound() async {
    await _audioPlayer.play(AssetSource('sounds/wrong.wav'));
  }

  // Artık ses oynatma işini dışarıdan kontrol ediyoruz
  void _animateAndDo(VoidCallback action, String button) {
    setState(() {
      if (button == 'increment') {
        _scaleIncrement = 1.1;
      } else if (button == 'reset') {
        _scaleReset = 1.1;
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        if (button == 'increment') {
          _scaleIncrement = 1.0;
        } else if (button == 'reset') {
          _scaleReset = 1.0;
        }
        action();
      });
    });
  }

  void _increment() {
    _playClickSound();
    _animateAndDo(() {
      _count = (_count + 1) % 10000;
    }, 'increment');
  }

  void _reset() {
    if (_count == 0) {
      _playWrongSound(); // sadece wrong.wav çal
    } else {
      _playClickSound(); // sadece sıfır değilse click.wav çal
    }

    _animateAndDo(() {
      _count = 0;
    }, 'reset');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          double maxHeight = constraints.maxHeight;

          double imageSize = maxWidth < maxHeight ? maxWidth : maxHeight;
          double fontSize = imageSize * 0.2;

          double displayTopRatio = 0.16;
          double displayRightRatio = 0.32;

          double resetTopRatio = 0.45;
          double resetLeftRatio = 0.60;

          double countTopRatio = 0.50;
          double countLeftRatio = 0.40;

          return Center(
            child: SizedBox(
              width: imageSize,
              height: imageSize,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/zikirmatik.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Sayaç
                  Positioned(
                    top: imageSize * displayTopRatio,
                    right: imageSize * displayRightRatio,
                    child: Text(
                      '$_count',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'DigitalMono',
                        color: Colors.cyanAccent,
                        shadows: const [
                          Shadow(blurRadius: 25, color: Colors.cyanAccent),
                        ],
                      ),
                    ),
                  ),
                  // Reset butonu
                  Positioned(
                    top: imageSize * resetTopRatio,
                    left: imageSize * resetLeftRatio,
                    child: GestureDetector(
                      onTap: _reset,
                      child: AnimatedScale(
                        scale: _scaleReset,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          width: imageSize * 0.08,
                          height: imageSize * 0.08,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border:
                                Border.all(color: Colors.purpleAccent, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.8),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(Icons.refresh,
                                color: Colors.white, size: imageSize * 0.04),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Zikir butonu
                  Positioned(
                    top: imageSize * countTopRatio,
                    left: imageSize * countLeftRatio,
                    child: GestureDetector(
                      onTap: _increment,
                      child: AnimatedScale(
                        scale: _scaleIncrement,
                        duration: const Duration(milliseconds: 100),
                        child: Container(
                          width: imageSize * 0.20,
                          height: imageSize * 0.20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border:
                                Border.all(color: Colors.purpleAccent, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purpleAccent.withOpacity(0.9),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.pan_tool_alt_rounded,
                              color: Colors.white,
                              size: imageSize * 0.12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  AnimatedText({
    required this.text,
    required this.style,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  List<String> _displayedCharacters = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Timer.periodic(widget.duration, (timer) {
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedCharacters.add(widget.text[_currentIndex]);
          _currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _displayedCharacters.map((char) {
        return AnimatedSwitcher(
          duration: widget.duration,
          child: Text(
            char,
            key: ValueKey(char),
            style: widget.style,
          ),
        );
      }).toList(),
    );
  }
}

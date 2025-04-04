import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class SplashToHomeTransition extends StatefulWidget {
  const SplashToHomeTransition({super.key});

  @override
  State<SplashToHomeTransition> createState() => _SplashToHomeTransitionState();
}

class _SplashToHomeTransitionState extends State<SplashToHomeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: const HomeScreen(),
    );
  }
}

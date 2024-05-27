import 'dart:async';

import 'package:flutter/material.dart';

class DelayAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const DelayAnimation({super.key, required this.delay, required this.child});

  @override
  State<DelayAnimation> createState() => _DelayAnimationState();
}

class _DelayAnimationState extends State<DelayAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500)
    );
    final curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _animOffset = Tween<Offset>(
      begin: const Offset(0.0,0.5),
      end: Offset.zero
    ).animate(curve);

    Timer(Duration(milliseconds: widget.delay), (){
      _controller.forward();
    });

  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}


class DelayTopAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  const DelayTopAnimation({super.key, required this.delay, required this.child});

  @override
  State<DelayTopAnimation> createState() => _DelayTopAnimationState();
}

class _DelayTopAnimationState extends State<DelayTopAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _animOffset;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500)
    );
    final curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _animOffset = Tween<Offset>(
        begin: const Offset(0.0,-0.5),
        end: Offset.zero
    ).animate(curve);

    Timer(Duration(milliseconds: widget.delay), (){
      _controller.forward();
    });

  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}


class DelayLetfAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  const DelayLetfAnimation({super.key, required this.delay, required this.child});

  @override
  State<DelayLetfAnimation> createState() => _DelayLetfAnimationState();
}

class _DelayLetfAnimationState extends State<DelayLetfAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _animOffset;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500)
    );
    final curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _animOffset = Tween<Offset>(
        begin: const Offset(-0.8,0.0),
        end: Offset.zero
    ).animate(curve);

    Timer(Duration(milliseconds: widget.delay), (){
      _controller.forward();
    });

  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}

class DelayRightAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  const DelayRightAnimation({super.key, required this.delay, required this.child});

  @override
  State<DelayRightAnimation> createState() => _DelayRightAnimationState();
}

class _DelayRightAnimationState extends State<DelayRightAnimation>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<Offset> _animOffset;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500)
    );
    final curve = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    _animOffset = Tween<Offset>(
        begin: const Offset(0.8,0.0),
        end: Offset.zero
    ).animate(curve);

    Timer(Duration(milliseconds: widget.delay), (){
      _controller.forward();
    });

  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}

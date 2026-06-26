import 'package:flutter/material.dart';

class MoveableWidget extends StatefulWidget {
  final Widget child;

  const MoveableWidget({super.key, required this.child});
  @override
  State<StatefulWidget> createState() {
    return _MoveableWidgetState();
  }
}

class _MoveableWidgetState extends State<MoveableWidget> {
  double xPosition = 0;
  double yPosition = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
          });
        },
        child: widget.child,
      ),
    );
  }
}

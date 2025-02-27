import 'package:flutter/material.dart';

class FullwidthButton extends StatefulWidget {
  const FullwidthButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = Colors.blue,
  });

  final VoidCallback onPressed;
  final Color backgroundColor;
  final Widget child;

  @override
  State<FullwidthButton> createState() => _FullwidthButtonState();
}

class _FullwidthButtonState extends State<FullwidthButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          8,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(widget.backgroundColor),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12.0),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final RxBool? isLoading; // optional reactive loading flag

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.amber,
    this.textColor = Colors.black,
    this.borderRadius = 14,
    this.isLoading,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double _scale = 1.0;

  void _onTapDown(_) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(_) {
    setState(() => _scale = 1.0);
    // Only call onPressed if not loading
    if (widget.isLoading == null || !widget.isLoading!.value) {
      widget.onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    // If isLoading is null, wrap in a simple widget
    if (widget.isLoading == null) {
      return _buildButton(false);
    }

    // Reactive version
    return Obx(() {
      return _buildButton(widget.isLoading!.value);
    });
  }

  Widget _buildButton(bool loading) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            elevation: 5,
          ),
          onPressed: loading ? null : widget.onPressed,
          child: loading
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: widget.textColor,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                ),
              ),
            ],
          )
              : Text(
            widget.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}

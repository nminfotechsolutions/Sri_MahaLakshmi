import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sri_mahalakshmi/core/utility/app_textstyles.dart';

import '../../../core/utility/app_colors.dart';

class MpinScreen extends StatefulWidget {
  final int pinLength;
  final void Function(String)? onCompleted;
  final String title;
  final String subtitle;

  const MpinScreen({
    Key? key,
    this.pinLength = 4,
    this.onCompleted,
    this.title = 'Enter MPIN',
    this.subtitle = 'Securely access your account',
  }) : super(key: key);

  @override
  State<MpinScreen> createState() => _MpinScreenState();
}

class _MpinScreenState extends State<MpinScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _shakeController;

  bool _obscurePin = true; // <-- NEW: for Show/Hide toggle

  String get _value => _controller.text;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.addListener(() {
      setState(() {});
      if (_controller.text.length >= widget.pinLength) {
        _focusNode.unfocus();
        widget.onCompleted?.call(
          _controller.text.substring(0, widget.pinLength),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _addDigit(String digit) {
    if (_controller.text.length >= widget.pinLength) return;
    _controller.text = (_controller.text + digit).trim();
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  void _backspace() {
    if (_controller.text.isEmpty) return;
    _controller.text = _controller.text.substring(
      0,
      _controller.text.length - 1,
    );
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  void _triggerError() {
    _shakeController.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 350), () {
      _controller.clear();
    });
  }

  Widget _buildPinFields() {
    final length = widget.pinLength;
    final value = _value;

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final offset = Tween<double>(
          begin: 0,
          end: 16,
        ).chain(CurveTween(curve: Curves.elasticIn)).evaluate(_shakeController);
        return Transform.translate(
          offset: Offset(offset * (0.5 - (DateTime.now().millisecond % 2)), 0),
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (i) {
          final filled = i < value.length;
          final char = filled ? value[i] : '';
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 64,
            width: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: filled ? AppColor.darkTeal : Colors.white,
              border: Border.all(color: AppColor.darkTeal, width: 1.5),
              boxShadow: filled
                  ? [
                      BoxShadow(
                        color: AppColor.darkTeal.withOpacity(0.25),
                        blurRadius: 8,
                      ),
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: filled
                  ? Text(
                      _obscurePin ? '•' : char,
                      key: ValueKey('pin_$i$_obscurePin'),
                      style: const TextStyle(fontSize: 28, color: Colors.white),
                    )
                  : const SizedBox(width: 10),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNumberButton(
    String label, {
    VoidCallback? onTap,
    Widget? child,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child:
                  child ??
                  Text(
                    label,
                    style: const TextStyle(fontSize: 22, color: Colors.black),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row in keys)
          Row(
            children: row
                .map((k) => _buildNumberButton(k, onTap: () => _addDigit(k)))
                .toList(),
          ),
        Row(
          children: [
            _buildNumberButton(''),
            _buildNumberButton('0', onTap: () => _addDigit('0')),
            _buildNumberButton(
              '',
              onTap: _backspace,
              child: const Icon(Icons.backspace_outlined, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFffaf4f2), // Soft beach white
              const Color(0xFFffaf4f2),
              const Color(0xFFffaf4f2),
              Color(0xFFB2DFDB),
              // Color(0xFFE0F2F1),
              // Color(0xFFB2DFDB),
              // Color(0xFF80CBC4),
              // Color(0xFF4DB6AC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColor.darkTeal,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.teal, Colors.blueAccent],
                              ),
                            ),
                            child: const Icon(
                              Icons.lock_outline,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: GoogleFonts.ibmPlexSans(
                                    color: Colors.teal.shade100,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.subtitle,
                                  style: GoogleFonts.ibmPlexSans(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildPinFields(),
                    const SizedBox(height: 16),

                    /// --- Paste + Eye Icon Row ---
                    Row(
                      children: [
                        TextButton(
                          onPressed: () async {
                            final data =
                                (await Clipboard.getData('text/plain'))?.text ??
                                '';
                            final digits = data.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            );
                            if (digits.isNotEmpty) {
                              final take = digits.substring(
                                0,
                                digits.length.clamp(0, widget.pinLength),
                              );
                              _controller.text = take;
                            }
                          },
                          child: const Text(
                            'Paste from clipboard',
                            style: TextStyle(color: AppColor.darkTeal),
                          ),
                        ),
                        Spacer(),
                        AppTextStyles.textWithSmall(
                          text: 'Show Pin',
                          color: AppColor.darkTeal,
                          fontSize: 15,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePin = !_obscurePin;
                            });
                          },
                          icon: Icon(
                            _obscurePin
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColor.darkTeal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColor.darkTeal.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildKeypad(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot MPIN?',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              'Unlock',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: _value.length == widget.pinLength
                                ? () => widget.onCompleted?.call(_value)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

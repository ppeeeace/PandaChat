import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.backgroundColor,
    this.child,
    required this.onTap,
    this.borderRadius,
    this.height,
    this.width,
    this.splashColor,
  });
  final Color? backgroundColor;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final Color? splashColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: borderRadius,
      child: InkWell(
        splashColor: splashColor,
        borderRadius: borderRadius,
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({
    Key? key,
    required this.child,
    required this.value,
    required this.onTap,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color? color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              // color: Theme.of(context).accentColor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color ?? Theme.of(context).hintColor,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ButtonRectangular extends StatelessWidget {
  final VoidCallback? onPressedFunction;
  final Widget child;
  final WidgetStateProperty<Size> size;
  final Color? color; 
  const ButtonRectangular(
      {super.key,
      required this.onPressedFunction,
        required this.child,
        this.size = const WidgetStatePropertyAll(Size(233, 50),),
        this.color
  }
  );
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        //fixedSize: WidgetStateProperty.all(const Size(233, 50)),
        fixedSize: size,
        backgroundColor: WidgetStateColor.resolveWith(
            (states) => color ?? const Color.fromRGBO(47, 39, 125, 1)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        )),
      ),
      onPressed: onPressedFunction,
      child: child,
    );
  }
}

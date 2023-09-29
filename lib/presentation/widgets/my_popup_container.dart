import 'package:flutter/material.dart';

class MyPopupContainer extends StatefulWidget {
  final Widget child;
  const MyPopupContainer({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyPopupContainerState();
}

class _MyPopupContainerState extends State<MyPopupContainer> {
  double height = 0;

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 0),
      () => setState(() => height = 400),
    );
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
        height: height,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: widget.child,
      ),
    );
  }
}

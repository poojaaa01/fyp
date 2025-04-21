import 'package:flutter/material.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager({super.key, required this.child, required this.isLoading});
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if(isLoading) ...[
          Container(color: Color.fromRGBO(0, 0, 0, 0.7)
          ),
          const Center(
            child: CircularProgressIndicator(
              color: Colors.redAccent,
            ),
          ),
        ]
      ],
    );
  }
}
import 'package:flutter/material.dart';

class DeleteComment extends StatelessWidget {
  final void Function()? onTap;

  const DeleteComment({super.key,
    required this.onTap,

  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: const Icon(
        Icons.delete,
        color: Colors.red,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ErrorLoadingIndicatore extends StatelessWidget {
  const ErrorLoadingIndicatore({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Someting went wrong!"),
    );
  }
}

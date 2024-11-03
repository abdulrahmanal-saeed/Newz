import 'package:flutter/material.dart';

class LoadingIndicatore extends StatelessWidget {
  const LoadingIndicatore({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

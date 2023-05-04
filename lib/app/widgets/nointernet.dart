import 'package:flutter/material.dart';

import '../../core/theme/style.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key, required this.errorText});
  final String errorText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/no internet.png'),
            const SizedBox(height: 40),
            Text(errorText, style: subheading1)
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';

import 'app/app.dart';

void main() {
  runApp(const _Home());
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Snake AI',
      debugShowCheckedModeBanner: false,
      home: YaruTheme(
        child: App(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webflix/screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  //key: 위젯은 ID 같은 식별자 역할의 key를 가지고
  // StatelessWidget에게 그 키를 보내는 것.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

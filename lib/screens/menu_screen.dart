import 'package:android_test_task/screens/authentication_pin_code_screen.dart';
import 'package:android_test_task/screens/create_pin_code_screen.dart';
import 'package:android_test_task/utils/abstract.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  static String routeName = 'MenuScreen';
  const MenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => _MenuScreenView(this);
}

class _MenuScreenView extends StatelessView<MenuScreen> {
  final widget;
  const _MenuScreenView(this.widget) : super(widget);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CreatePinCodeScreen.routeName);
              },
              child: const Text(
                'Create PIN code',
                style: TextStyle(),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushNamed(AuthenticationPinCodeScreen.routeName);
                },
                child: const Text('Authenticate Pin Code'))
          ],
        ),
      )),
    );
  }
}

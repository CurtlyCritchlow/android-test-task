import 'package:android_test_task/screens/menu_screen.dart';
import 'package:android_test_task/utils/abstract.dart';
import 'package:android_test_task/widgets/hidden_password_icon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationPinCodeScreen extends StatefulWidget {
  static String routeName = 'AuthenticationPinCodeScreen';
  const AuthenticationPinCodeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AuthenticationPinCodeScreenController createState() =>
      _AuthenticationPinCodeScreenController();
}

class _AuthenticationPinCodeScreenController
    extends State<AuthenticationPinCodeScreen> {
  @override
  Widget build(BuildContext context) => _CreatePinCodeScreenView(this);
  late final String sharedPrefsPassword;
  late List<Widget> passwordIcons = passwordIcons = [
    HiddenPasswordIcon(isCircleOutlined: true),
    HiddenPasswordIcon(isCircleOutlined: true),
    HiddenPasswordIcon(isCircleOutlined: true),
    HiddenPasswordIcon(isCircleOutlined: true)
  ];

  late TextEditingController passwordController;

  @override
  void initState() {
    passwordController = TextEditingController();
    handleReadPasswordFromSharedPreferences();

    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void handleReadPasswordFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    sharedPrefsPassword = prefs.getString('password')!;
  }

  // Show hidden password icon to match number of digits entered
  void handleHiddenPasswordIcon() {
    if (passwordController.text.isEmpty) {
      passwordIcons = [
        HiddenPasswordIcon(isCircleOutlined: true),
        HiddenPasswordIcon(isCircleOutlined: true),
        HiddenPasswordIcon(isCircleOutlined: true),
        HiddenPasswordIcon(isCircleOutlined: true),
      ];
    } else if (passwordController.text.length == 1) {
      passwordIcons = [
        HiddenPasswordIcon(isCircleOutlined: false),
        HiddenPasswordIcon(isCircleOutlined: true),
        HiddenPasswordIcon(isCircleOutlined: true),
        HiddenPasswordIcon(isCircleOutlined: true),
      ];
    } else if (passwordController.text.length == 2) {
      passwordIcons = [
        HiddenPasswordIcon(isCircleOutlined: false),
        HiddenPasswordIcon(isCircleOutlined: false),
        HiddenPasswordIcon(isCircleOutlined: true),
        HiddenPasswordIcon(isCircleOutlined: true),
      ];
    } else if (passwordController.text.length == 3) {
      passwordIcons = [
        HiddenPasswordIcon(isCircleOutlined: false),
        HiddenPasswordIcon(isCircleOutlined: false),
        HiddenPasswordIcon(isCircleOutlined: false),
        HiddenPasswordIcon(isCircleOutlined: true),
      ];
    } else {
      passwordIcons = [
        HiddenPasswordIcon(isCircleOutlined: false),
        HiddenPasswordIcon(isCircleOutlined: false),
        HiddenPasswordIcon(isCircleOutlined: false),
        HiddenPasswordIcon(isCircleOutlined: false),
      ];
    }
    setState(() {});
  }

  void handleOnChanged(String password) {
    handleHiddenPasswordIcon();
    if (passwordController.text.length == 4 &&
        sharedPrefsPassword == passwordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Your PIN has been set up successfully!'),
          content: TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.of(context).pushNamed(MenuScreen.routeName);
              },
              child: const Text('Ok')),
        ),
      );
    } else if (passwordController.text.length == 4 &&
        sharedPrefsPassword != passwordController.text) {
      setState(() {
        passwordController.clear();
        handleHiddenPasswordIcon();
      });
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text('Authentication failed'),
              ));
    }
  }
}

class _CreatePinCodeScreenView extends WidgetView<AuthenticationPinCodeScreen,
    _AuthenticationPinCodeScreenController> {
  final state;
  const _CreatePinCodeScreenView(this.state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Enter your PIN',
              style: TextStyle(color: Colors.grey, fontSize: 40),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: state.passwordIcons,
            ),
            TextField(
              controller: state.passwordController,
              keyboardType: TextInputType.number,
              autofocus: true,
              obscureText: true,
              showCursor: false,
              maxLength: 4,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              onChanged: state.handleOnChanged,

              // onSubmitted: ,
            )
          ],
        ),
      ),
    );
  }
}

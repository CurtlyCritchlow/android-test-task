import 'package:android_test_task/screens/menu_screen.dart';
import 'package:android_test_task/utils/abstract.dart';
import 'package:android_test_task/widgets/hidden_password_icon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePinCodeScreen extends StatefulWidget {
  static String routeName = 'CreatePinCodeScreen';
  const CreatePinCodeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CreatePinCodeScreenController createState() =>
      _CreatePinCodeScreenController();
}

class _CreatePinCodeScreenController extends State<CreatePinCodeScreen> {
  @override
  Widget build(BuildContext context) => _CreatePinCodeScreenView(this);

  bool isFirstPasswordEntry = true;
  late String firstPasswordEntry;
  String pinStageStatus = 'Create PIN';
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

    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void handlePinStageStatus() {
    if (isFirstPasswordEntry) {
      pinStageStatus = 'Create PIN';
    } else {
      pinStageStatus = 'Re-enter your PIN';
    }
    setState(() {});
  }

  void handleSavePasswordToSharedPreferences(String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  // Show hidden password icon to match number of digits entered
  void handleHiddenPasswordIcon() {
    if (passwordController.text.length == 0) {
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
  }

  void handleOnChanged(String password) {
    handleHiddenPasswordIcon();
    if (passwordController.text.length == 4) {
      isFirstPasswordEntry ? firstPasswordEntry = password : null;
      isFirstPasswordEntry ? passwordController.clear() : null;
      isFirstPasswordEntry = false;
      handlePinStageStatus();
      handleHiddenPasswordIcon();
      if (passwordController.text.length == 4) {
        if (firstPasswordEntry == passwordController.text) {
          handleSavePasswordToSharedPreferences(passwordController.text);
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
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('You did not re-enter the same password'),
                    content: TextButton(
                        onPressed: () {
                          pinStageStatus = 'Create PIN';
                          isFirstPasswordEntry = true;
                          setState(() {
                            passwordController.clear();
                            handleHiddenPasswordIcon();
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok')),
                  ));
        }
      }
    }
    setState(() {});
  }
}

class _CreatePinCodeScreenView
    extends WidgetView<CreatePinCodeScreen, _CreatePinCodeScreenController> {
  final state;
  const _CreatePinCodeScreenView(this.state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Pin'),
        actions: const [
          Text(
            'Use 6-digits PIN',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            state.pinStageStatus,
            style: const TextStyle(color: Colors.grey, fontSize: 40),
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
    );
  }
}

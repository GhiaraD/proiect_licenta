import 'package:SoundTrek/pages/BottomNavigation.dart';
import 'package:SoundTrek/resources/colors.dart' as my_colors;
import 'package:SoundTrek/resources/themes.dart' as my_themes;
import 'package:SoundTrek/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'RegisterView.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthenticationService apiService = AuthenticationService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isObscuredPassword = true;

  Future<bool> _login() async {
    try {
      await apiService.login(
        _emailController.text,
        _passwordController.text,
      );
      print('Login successful');
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscuredPassword = !_isObscuredPassword;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: my_colors.Colors.greyBackground,
      appBar: AppBar(
        title: const Text('Log In', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: my_colors.Colors.greyBackground,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: my_colors.Colors.greyBackground,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: my_colors.Colors.greyBackground,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              cursorColor: my_colors.Colors.primary,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: my_colors.Colors.primary, width: 5),
                ),
                floatingLabelStyle: TextStyle(color: my_colors.Colors.primary, fontWeight: FontWeight.bold),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: my_colors.Colors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: _isObscuredPassword ? true : false,
              cursorColor: my_colors.Colors.primary,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                floatingLabelStyle: const TextStyle(color: my_colors.Colors.primary, fontWeight: FontWeight.bold),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: my_colors.Colors.primary, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscuredPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: const Text('Trouble logging in?', style: TextStyle(color: my_colors.Colors.primary)),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              style: _isButtonEnabled
                  ? (my_themes.Themes.buttonHalfPageStyle)
                  : (my_themes.Themes.buttonHalfPageStyleDisabled),
              onPressed: _isButtonEnabled
                  ? () async {
                      bool loggedIn = await _login();
                      if (loggedIn) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const NavigationExample()),
                          ModalRoute.withName('/'),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login failed. Please try again.'),
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text('Log In'),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterView()),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    Text("Sign Up ", style: TextStyle(color: my_colors.Colors.primary)),
                    Text("for one."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

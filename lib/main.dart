import 'package:autologin/screens/settings_page.dart';
import 'package:autologin/utils/credentials_service.dart';
import 'package:autologin/utils/login_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:autologin/utils/theme_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF4A90E2),
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          cardColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4A90E2),
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF333333)),
            bodyMedium: TextStyle(color: Color(0xFF555555)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF4A90E2),
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardColor: const Color(0xFF363636),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF363636),
            foregroundColor: Color(0xFFE0E0E0),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
            bodyMedium: TextStyle(color: Color(0xFFB0B0B0)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        themeMode: theme.themeMode,
        home: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginService _loginService = LoginService();
  final CredentialsService _credentialsService = CredentialsService();
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String _statusMessage = "";

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
    _checkInitialLoginStatus();
  }

  Future<void> _checkInitialLoginStatus() async {
    setState(() {
      _isLoading = true;
    });
    final isLoggedIn = await _loginService.checkLoginStatus();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  Future<void> _loadCredentials() async {
    final credentials = await _credentialsService.getCredentials();
    _usernameController.text = credentials['username'] ?? '';
    _passwordController.text = credentials['password'] ?? '';
  }

  @override
  void dispose() {
    _loginService.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Logging in...";
    });

    try {
      final String? errorMessage = await _loginService.performLogin(
        _usernameController.text,
        _passwordController.text,
      );

      final isLoggedIn = await _loginService.checkLoginStatus();
      setState(() {
        _isLoggedIn = isLoggedIn;
      });

      if (errorMessage == null) {
        setState(() {
          _isLoading = false;
          _statusMessage = "Login Successful!";
        });
      } else {
        setState(() {
          _isLoading = false;
          _statusMessage = errorMessage;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "An error occurred: $e";
      });
    }
  }

  Future<void> _handleLogout() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Logging out...";
    });

    try {
      final String? errorMessage = await _loginService.performLogin(
        "",
        "",
      ); // Perform logout
      final isLoggedIn = await _loginService.checkLoginStatus();

      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
        if (errorMessage == null) {
          _statusMessage = "Logged Out Successfully!";
        } else {
          _statusMessage = errorMessage;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "An error occurred: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Portal Login"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => SettingsPage()),
              ).then((_) => _loadCredentials());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLoggedIn) ...[
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                    ],
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : (_isLoggedIn ? _handleLogout : _handleLogin),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : Text(_isLoggedIn ? "Logout" : "Login"),
                    ),
                    if (_statusMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          _statusMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                _statusMessage == "Login Successful!" ||
                                    _statusMessage == "Logged Out Successfully!"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => launchUrl(Uri.parse('https://github.com/ram3ez')),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.github,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Built by Ram3ez',
                    style: TextStyle(
                      color: Colors.blue,
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

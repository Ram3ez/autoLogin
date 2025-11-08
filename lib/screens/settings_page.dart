import 'package:autologin/utils/theme_notifier.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:autologin/utils/credentials_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _credentialsService = CredentialsService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final credentials = await _credentialsService.getCredentials();
    _usernameController.text = credentials['username'] ?? '';
    _passwordController.text = credentials['password'] ?? '';
  }

  Future<void> _saveCredentials() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    await _credentialsService.saveCredentials(username, password);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Credentials saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _saveCredentials,
                      child: Text('Save Credentials'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Consumer<ThemeNotifier>(
              builder: (context, theme, _) => Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SwitchListTile(
                  title: Text('Dark Mode'),
                  value: theme.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    theme.toggleTheme(value);
                  },
                ),
              ),
            ),
            Spacer(),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Built by Ram3ez ©'),
                    trailing: Icon(Icons.code),
                  ),
                  ListTile(
                    title: Text('GitHub'),
                    trailing: Icon(Icons.open_in_new),
                    onTap: () {
                      launchUrl(
                        Uri.parse('https://github.com/Ram3ez/autoLogin'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:autologin/utils/credentials_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _credentialsService = CredentialsService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _saveStatus = '';

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
    setState(() {
      _saveStatus = 'Credentials saved!';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Credentials saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
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
            SizedBox(height: 16.0),
            if (_saveStatus.isNotEmpty)
              Text(
                _saveStatus,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}

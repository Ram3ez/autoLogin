import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'dart:io'; // Import for HttpClient
import 'package:http/io_client.dart'; // Import for IOClient

/// A service class to handle the captive portal login process.
class LoginService {
  final http.Client _client;

  // This is a common URL that captive portals intercept.
  // When you request this, the portal should redirect you to the
  // real login page, including all the query parameters.
  final String _portalCheckUrl = "https://192.168.30.8:9998/SubscriberPortal/";
  //"https://smartzone1.nitpy.ac.in:9998/SubscriberPortal/login";

  LoginService()
    // Creates a client that bypasses SSL certificate checks.
    // WARNING: Only use this for a trusted, internal-only server.
    // This is a major security risk on the public internet.
    : _client = IOClient(
        HttpClient()
          ..badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true),
      );

  /// Attempts to log in to the portal with the given credentials.
  ///
  /// Returns `null` for success, or an error message string for any failure.
  Future<String?> performLogin(String username, String password) async {
    // Add headers to mimic a real web browser
    final headers = {
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    };

    try {
      // --- Step 1: GET request to detect and get the portal URL ---

      final checkUri = Uri.parse(_portalCheckUrl);

      final responseGet = await _client.get(checkUri, headers: headers);

      // The http.Client follows redirects by default.
      // We can get the *final* URL (the login page) from the response.
      final loginPageUri = responseGet.request!.url;

      if (responseGet.statusCode != 200) {
        final errorMessage =
            "Failed to fetch login page: ${responseGet.statusCode}";
        return errorMessage;
      }

      // --- Step 2: Extract dynamic form values ---
      final document = html.parse(responseGet.body);
      bool isLogout = false;

      // This is the data we will send in our POST request
      final payload = {'UE-Username': username, 'UE-Password': password};

      final loginForm = document.querySelector('form[name="loginForm"]');
      if (loginForm == null) {
        const errorMessage =
            "Error: Could not find the login form on the page.";

        return errorMessage;
      }

      final hiddenInputs = loginForm.querySelectorAll('input[type="hidden"]');

      for (var inputTag in hiddenInputs) {
        final name = inputTag.attributes['name'];
        final value = inputTag.attributes['value'];
        if (name != null && value != null) {
          if (name == "RequestType" && value == "Logout") {
            isLogout = true;
          }

          payload[name] = value;
        }
      }

      // --- Step 3: POST request to submit the login ---

      // We MUST POST back to the full login page URI,
      // including all its query parameters
      final responsePost = await _client.post(
        loginPageUri,
        headers: headers,
        body: payload,
      );

      if (responsePost.statusCode != 200) {
        final errorMessage =
            "Login POST request failed: ${responsePost.statusCode}";

        return errorMessage;
      }

      // --- Step 4: Check if login was successful ---
      final responseBody = responsePost.body;
      if (responseBody.contains("Login successful") ||
          responseBody.contains("Welcome")) {
        return null; // Success
      } else if (isLogout) {
        return "Logged Out";
      } else if (responseBody.contains(
        "Login failed. Please check your login password, and then try again.",
      )) {
        const errorMessage = "Invalid username or password.";

        return errorMessage;
      } else {
        const errorMessage = "Login submitted, but the outcome is unknown.";
        return errorMessage;
      }
    } catch (e) {
      final errorMessage = "An unexpected error occurred: $e";
      return errorMessage;
    }
  }

  /// Call this from your Flutter widget's `dispose()` method
  /// to free up resources when the app is closed.
  void dispose() {
    _client.close();
  }
}

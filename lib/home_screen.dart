import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAuthenticated = false;
  final LocalAuthentication _authentication = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: _authButton(),
    );
  }

  // Button for Pattern Authentication
  Future<void> _authenticateWithPattern() async {
    await _authenticate(biometricOnly: false);
  }

  // Button for Biometric Authentication (Fingerprint or Face ID)
  Future<void> _authenticateWithBiometrics() async {
    await _authenticate(biometricOnly: true);
  }

  // Unified Authentication Method
  Future<void> _authenticate({required bool biometricOnly}) async {
    bool isAuthenticated = false;
    try {
      final bool canAuthenticateWithBiometrics = await _authentication.canCheckBiometrics;

      if (canAuthenticateWithBiometrics || !biometricOnly) {
        isAuthenticated = await _authentication.authenticate(
          localizedReason: 'Please authenticate to access your account balance',
          options: AuthenticationOptions(biometricOnly: biometricOnly),
        );
      }

      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    } catch (e) {
      print("Authentication error: $e");
    }
  }

  // Authentication Buttons for Different Methods
  Widget _authButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: _authenticateWithBiometrics,
          label: const Text("Biometrics"),
          icon: const Icon(Icons.fingerprint),
        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          onPressed: _authenticateWithPattern,
          label: const Text("Pattern"),
          icon: const Icon(Icons.lock),
        ),
      ],
    );
  }

  // UI Builder
  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Account Balance",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          if (_isAuthenticated)
            const Text(
              "\$ 25,632",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          if (!_isAuthenticated)
            const Text(
              "******",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

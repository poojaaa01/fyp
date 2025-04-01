import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy and Policy"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
            Privacy Policy
            
            This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application.
            
            1. **Information Collection**: We may collect personal information such as your name, email, and preferences.
            2. **Usage of Information**: Your data is used to enhance user experience, improve services, and ensure security.
            3. **Data Security**: We take precautions to protect your data but cannot guarantee 100% security.
            4. **Third-Party Services**: Some features may involve third-party services that have their own policies.
            5. **Policy Updates**: We may update our Privacy Policy from time to time.
            
            If you have any questions, feel free to contact us at support@example.com.
            ''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

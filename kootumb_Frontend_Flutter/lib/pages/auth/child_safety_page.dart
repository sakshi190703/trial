import 'package:flutter/material.dart';
import 'package:Kootumb/provider.dart';

class ChildSafetyPage extends StatefulWidget {
  const ChildSafetyPage({Key? key}) : super(key: key);

  @override
  State<ChildSafetyPage> createState() => _ChildSafetyPageState();
}

class _ChildSafetyPageState extends State<ChildSafetyPage> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Child Safety Policy",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 24, 107),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  """Child Safety Policy

We are committed to ensuring the safety and well-being of children using our services. 
Our policy includes the following points:

1. Protect children from any form of harm, abuse, or exploitation.  
2. Provide a safe environment for children in both physical and online spaces.  
3. Respect children's rights, privacy, and dignity.  
4. Encourage parents/guardians to be aware of children's activities.  
5. Take immediate action in case of safety concerns.  

By continuing, you acknowledge that you have read and agreed to our Child Safety Policy.

For complete policies, terms of service, and privacy policy, please visit our policies page.
""",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: _isAgreed,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "I have read and agree to the Child Safety Policy",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                var kongoProvider = KongoProvider.of(context);
                kongoProvider.urlLauncherService
                    .launchUrlInApp('https://kootumb.com/policies.html');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 11, 24, 107),
                side: const BorderSide(color: Color.fromARGB(255, 11, 24, 107)),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text("View Complete Policies"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isAgreed
                  ? () {
                      Navigator.pushReplacementNamed(context, '/auth/login');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Policy accepted!")),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 11, 24, 107),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}

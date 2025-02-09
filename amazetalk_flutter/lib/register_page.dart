import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _showInputValues() {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    print("Username: $username, Email: $email, Password: $password");
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextInput("Username", Icons.person, _usernameController),
                SizedBox(height: 20),
                _buildTextInput("Email", Icons.person, _emailController),
                SizedBox(height: 20),
                _buildTextInput("Password", Icons.person, _passwordController,
                    isPassword: true),
                SizedBox(height: 20),
                _buildRegisterButton(),
                SizedBox(height: 20),
                _buildLoginPrompt(),
              ],
            )),
      ),
    );
  }

  Widget _buildTextInput(
      String hint, IconData icon, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 252, 240, 240),
          borderRadius: BorderRadius.circular(25)),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _showInputValues,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.grey),
        padding: WidgetStateProperty.all(EdgeInsets.all(15)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        )),
      ),
      child: const Text("Register"),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: RichText(
          text: TextSpan(
              text: "Already have an account? ",
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                  text: "Login",
                  style: TextStyle(color: Colors.blue),
                )
              ]),
        ),
      ),
    );
  }
}

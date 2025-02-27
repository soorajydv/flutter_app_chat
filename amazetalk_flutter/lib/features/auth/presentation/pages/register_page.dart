import 'dart:io';
import 'package:amazetalk_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:amazetalk_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:amazetalk_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:amazetalk_flutter/features/auth/presentation/widgets/auth_button.dart';
import 'package:amazetalk_flutter/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:amazetalk_flutter/features/auth/presentation/widgets/login_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _imageFile; // Stores the selected image file

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Picks an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  /// Handles the registration process
  void _onRegister() {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    BlocProvider.of<AuthBloc>(context).add(
      RegisterEvent(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        imageFile: _imageFile, // Send the image file to the Bloc
      ),
    );
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
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile == null
                    ? Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape
                              .circle, // Ensures the shape is always circular
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: const Center(
                          child: Icon(Icons.camera_alt,
                              size: 50, color: Colors.grey),
                        ),
                      )
                    : CircleAvatar(
                        radius: 60, // Ensure consistent circular size
                        backgroundImage:
                            FileImage(_imageFile!), // Display picked image
                        backgroundColor:
                            Colors.transparent, // Remove any background color
                      ),
              ),
              const SizedBox(height: 20),
              AuthInputField(
                hint: "Username",
                icon: Icons.person,
                controller: _usernameController,
              ),
              const SizedBox(height: 20),
              AuthInputField(
                hint: "Email",
                icon: Icons.email,
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              AuthInputField(
                hint: "Password",
                icon: Icons.lock,
                controller: _passwordController,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 40),
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return AuthButton(text: "Register", onPressed: _onRegister);
                },
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.pushNamed(context, AppRoutes.login);
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
              ),
              const SizedBox(height: 20),
              LoginPrompt(
                title: "Already have an account?",
                subtitle: "Login",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

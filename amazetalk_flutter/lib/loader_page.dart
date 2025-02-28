import 'package:amazetalk_flutter/app_routes.dart';
import 'package:amazetalk_flutter/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:amazetalk_flutter/widgets/loader.dart';
import 'package:flutter/material.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  void _checkToken(BuildContext context) async {
    final token = await AuthLocalDataSource().getToken();
    if (token != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.conversations,
        (route) => false,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkToken(context);
    return Scaffold(
      body: Center(child: Loader()),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:amazetalk_flutter/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:amazetalk_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:amazetalk_flutter/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(GetCacheData());
    return Drawer(
      child: Column(
        children: [
          // Drawer Header with Avatar

          BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            if (state is CacheDataFetched) {
              final user = state.user;
              print('Image: ${user.image}');
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                accountName: Text(user.image),
                accountEmail: Text(user.email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: user.image.isEmpty
                      ? Icon(
                          Icons.person,
                          color: Colors.blue,
                          size: 50,
                        )
                      : Image.asset(user.image),
                ),
              );
            }
            return Loader();
          }),

          // Drawer Menu Items
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              // Handle Home navigation
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              // Handle Profile navigation
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Handle Settings navigation
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
              // Handle Notifications navigation
            },
          ),

          // Spacer to push logout button to the bottom
          Spacer(),

          // Logout Button at the bottom
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              // Handle Logout action
              Navigator.pop(context); // Close the drawer
              // Implement logout functionality here
              print('Logged out');

              await AuthLocalDataSource().clear();

              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

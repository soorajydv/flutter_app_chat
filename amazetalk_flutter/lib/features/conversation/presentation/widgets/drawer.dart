import 'package:amazetalk_flutter/constants/urls.dart';
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
    // Trigger the event only once when the widget is built
    BlocProvider.of<AuthBloc>(context).add(GetCacheData());

    return Drawer(
      child: Column(
        children: [
          // Drawer Header with Enhanced CircleAvatar
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is CacheDataFetched) {
                final user = state.user;
                print('Avatar URL: ${BACKEND_URL + user.avatar}');

                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    // Optional: Add gradient
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue, Colors.blueAccent],
                    ),
                  ),
                  accountName: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  accountEmail: Text(
                    user.email,
                    style: const TextStyle(fontSize: 14),
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 36, // Adjust size as needed
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: user.avatar.isEmpty
                          ? const Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 50,
                            )
                          : Image.network(
                              BACKEND_URL + user.avatar,
                              fit: BoxFit.cover,
                              width: 72, // Double the radius
                              height: 72,
                              // loadingBuilder: (context, _, __) =>
                              //     const CircularProgressIndicator(
                              //   color: Colors.blue,
                              // ),
                              errorBuilder: (context, url, error) => const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                    ),
                  ),
                );
              }
              return const Loader();
            },
          ),

          // Drawer Menu Items
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Spacer(),

          // Logout Button
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              Navigator.pop(context);
              try {
                await AuthLocalDataSource().clear();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login,
                    (route) => false,
                  );
                }
              } catch (e) {
                print('Logout error: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logout failed')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

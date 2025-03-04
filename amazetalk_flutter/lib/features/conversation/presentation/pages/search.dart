import 'dart:convert';

import 'package:amazetalk_flutter/constants/urls.dart';
import 'package:amazetalk_flutter/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _results = [];
  bool _loading = false;
  bool _error = false;

  /// Calls the /fetchUsers API using the provided search query.
  Future<void> _fetchUsers(String query) async {
    setState(() {
      _loading = true;
      _error = false;
    });
    final token = await AuthLocalDataSource().getToken();
    try {
      // Adjust the endpoint and query parameter as needed.
      final response = await http.get(
        Uri.parse('$BACKEND_URL/fetchUsers?search=$query'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _results = data;
        });
      } else {
        setState(() {
          _error = true;
        });
      }
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  /// Displays the search results in a popup dialog.
  void _showResultsPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Results'),
          content: _loading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  width: double.maxFinite,
                  child: _results.isEmpty
                      ? const Text('No users found.')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final user = _results[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: user['image'] != null
                                      ? NetworkImage(user['image'])
                                      : null,
                                  child: user['image'] == null
                                      ? Text(user['name'][0])
                                      : null,
                                ),
                                title: Text(user['name'] ?? ''),
                                subtitle: Text(user['email'] ?? ''),
                              ),
                            );
                          },
                        ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Builds an AppBar that toggles between a title and a search field.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search Users...',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  final query = value.trim();
                  if (query.isNotEmpty) {
                    _fetchUsers(query).then((_) => _showResultsPopup());
                  }
                },
              )
            : const Text('Search Users'),
        actions: [
          isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      isSearching = false;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
        ],
      ),
      body: const Center(
        child: Text('Enter a search query from the AppBar.'),
      ),
    );
  }
}

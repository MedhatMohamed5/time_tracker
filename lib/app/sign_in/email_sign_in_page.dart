import 'package:flutter/material.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('Time Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: _buildContent(),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Container();
  }
}

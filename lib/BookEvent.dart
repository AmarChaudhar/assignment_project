import 'package:flutter/material.dart';

class BookedPageScreen extends StatelessWidget {
  const BookedPageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Back'),
      ),
      body: const Center(
        child: Text('Booking Successfully'),
      ),
    );
  }
}

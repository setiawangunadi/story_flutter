import 'package:flutter/material.dart';

class DetailStoryScreen extends StatefulWidget {
  const DetailStoryScreen({super.key});

  @override
  State<DetailStoryScreen> createState() => _DetailStoryScreenState();
}

class _DetailStoryScreenState extends State<DetailStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Story"),
      ),
    );
  }
}

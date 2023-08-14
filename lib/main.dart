import 'dart:io';

import 'package:eco_icons_downloader/donwload_fragment.dart';
import 'package:eco_icons_downloader/extract_fragment.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

enum Status {
  ready,
  progress,
  failed,
  complete,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoIcons Downloader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _index = 0;

  int get index => _index;

  set index(int value) {
    setState(() {
      _index = value;
    });
  }

  String path = "";

  void onDownloadComplete(String path) async {
    setState(() {
      index = 1;
      this.path = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: index,
        children: [
          // Download
          DownloadFragment(onComplete: onDownloadComplete),
          // Extract
          ExtractFragment(path: path)
        ],
      ),
    );
  }
}

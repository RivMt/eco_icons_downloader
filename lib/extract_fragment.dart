import 'dart:io';

import 'package:eco_icons_downloader/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';

class ExtractFragment extends StatefulWidget {

  final String path;

  const ExtractFragment({
    super.key,
    required this.path,
  });

  @override
  State createState() => _ExtractFragmentState();

}

class _ExtractFragmentState extends State<ExtractFragment> {

  Status status = Status.ready;

  double progress = 0;

  void extract(String path) async {
    final zip = File(path);
    final dest = await (Directory("/storage/emulated/0/Download/Onyx/icon").create(recursive: true));
    try {
      ZipFile.extractToDirectory(
        zipFile: zip,
        destinationDir: dest,
        onExtracting: onProgress,
      );
    } catch(e) {
      if (kDebugMode) {
        print(e);
      }
      onError();
    }
  }

  void onError() {
    setState(() {
      status = Status.failed;
    });
  }

  ZipFileOperation onProgress(ZipEntry entry, double p) {
    if (p >= 1) {
      onComplete();
    }
    if (p - progress >= 0.01) {
      setState(() {
        progress = p;
      });
    }
    return ZipFileOperation.includeItem;
  }

  void onComplete() {
    setState(() {
      status = Status.complete;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IndexedStack(
        index: status.index,
        children: [
          // Ready
          TextButton(
            onPressed: () => extract(widget.path),
            child: const Text("Apply"),
          ),
          // Progress
          LinearProgressIndicator(
            value: progress,
          ),
          // Failed
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Failed"),
              TextButton(
                onPressed: () => extract(widget.path),
                child: const Text("Apply"),
              ),
            ],
          ),
          // Complete
          const Icon(Icons.done_outline),
        ],
      ),
    );
  }

}
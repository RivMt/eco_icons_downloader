import 'package:eco_icons_downloader/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

const String filename = "icons.zip";

class DownloadFragment extends StatefulWidget {

  final Function(String) onComplete;

  const DownloadFragment({
    super.key,
    required this.onComplete,
  });

  @override
  State createState() => _DownloaderFragmentState();

}

class _DownloaderFragmentState extends State<DownloadFragment> {

  Status status = Status.ready;

  double progress = 0;

  void download() async {
    final url = await rootBundle.loadString('assets/url');
    FileDownloader.downloadFile(
      url: url,
      name: filename,
      onProgress: onProgress,
      onDownloadCompleted: onComplete,
      onDownloadError: onFailed
    );
    setState(() {
      progress = 0;
      status = Status.progress;
    });
  }

  dynamic onProgress(String? filename, double p) {
    if (p - progress >= 0.01) {
      setState(() {
        progress = p;
      });
    }
  }

  onComplete(String path) {
    widget.onComplete(path);
  }

  onFailed(String error) {
    setState(() {
      status = Status.failed;
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
            onPressed: () => download(),
            child: const Text("Download"),
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
                onPressed: () => download(),
                child: const Text("Download"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
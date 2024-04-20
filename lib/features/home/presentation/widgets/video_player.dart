import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:lilac_task/core/common/loader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String videoId;

  // Path to your video asset or network URL

  const VideoPlayerWidget({Key? key, required this.videoUrl,required this.videoId}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool? file;
  Future<bool> checkFileExists() async {
    File file = File('/storage/emulated/0/Download/${widget.videoId}.mp4');
    return await file.exists();
  }

   FlickManager? flickManager;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then((value) async {
      file=await checkFileExists();
      setState(() {

      });
    });
    // _checkIfVideoDownloaded();
    // flickManager = FlickManager(
    //     videoPlayerController:
    //     VideoPlayerController.file(File('/storage/emulated/0/Download/${widget.videoId}.mp4'))
    // );
    super.initState();
    // Initialize the controller with the video URL
  }
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    flickManager!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return AspectRatio(
    aspectRatio: 16 / 9, // You can adjust this aspect ratio according to your video's aspect ratio
    child: file!=null?FlickVideoPlayer(

      flickManager: file!?FlickManager(
          videoPlayerController:
          VideoPlayerController.file(File('/storage/emulated/0/Download/${widget.videoId}.mp4'))
      ):FlickManager(
        videoPlayerController:
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl)),
      ),
    ):const Center(child: Loader(),),
    );
  }
}
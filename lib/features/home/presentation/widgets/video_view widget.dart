import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lilac_task/core/common/loader.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../core/constant/video_index/bloc/video_index_bloc.dart';
class VideoViewWidget extends StatefulWidget {
  final String url;
  final String name;
  final int index;
  const VideoViewWidget({super.key,required this.url,required this.name,required this.index});

  @override
  State<VideoViewWidget> createState() => _VideoViewWidgetState();
}

class _VideoViewWidgetState extends State<VideoViewWidget> {
  @override
  void initState() {
    _getThumbnail();
    super.initState();
  }
  Uint8List? thumbnailBytes;


  Future<void> _getThumbnail() async {
    try {
      thumbnailBytes = await VideoThumbnail.thumbnailData(video:widget.url,imageFormat:ImageFormat.JPEG,quality: 75  );

      setState(() {}); // Update UI to display thumbnail
    } catch (error) {
      print('Error getting thumbnail: $error');
      // Handle error gracefully, e.g., display a placeholder image
    }
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        context.read<VideoIndexBloc>().add(ChangeIndex(index: widget.index));
      },
      child: SizedBox(

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             Stack(fit: StackFit.passthrough,
               children: [

                 thumbnailBytes!=null
                      ? BlocBuilder<VideoIndexBloc,int>(builder: (context, state) {
                   return SizedBox(
                     width: width*0.25,
                     height:width*0.25 ,
                     child: Stack(alignment: Alignment.center,
                       children: [
                         Image.memory(
                           thumbnailBytes!,

                           fit: BoxFit.contain,
                         ),
                         if(state==widget.index)
                         Container(
                           width: width*0.25,
                           height:height*0.06,
                           color: Colors.grey.withOpacity(0.4),
                           child: const Center(child: Text("Playing..")),
                         ),
                       ],
                     ),
                   );
                      },)

                      : SizedBox(
                    width: width*0.05,
                      height: width*0.05,
                      child: const Center(child: Loader(),)),

               ],
             ),
              SizedBox(
                width: width*0.6,
                  child: Text(widget.name,style: TextStyle(fontSize: width*0.04,fontWeight: FontWeight.bold),))
            ],
            ),
            const Divider(thickness: 2,)
          ],
        ),
      ),
    );
  }
}

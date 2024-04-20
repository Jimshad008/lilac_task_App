import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart'as http;
import 'package:lilac_task/core/constant/video_index/bloc/video_index_bloc.dart';
import 'package:lilac_task/features/auth/data/model/user_data_model.dart';
import 'package:lilac_task/features/home/presentation/bloc/home_bloc.dart';
import 'package:lilac_task/features/home/presentation/widgets/video_player.dart';
import 'package:lilac_task/features/home/presentation/widgets/video_view%20widget.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/common/loader.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../widgets/profile_drawer.dart';
import '../widgets/setting_drawer.dart';
class HomePage extends StatefulWidget {
  final UserDataModel user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _downloadVideo(String videoId,String videoUrl) async {
    Future<void> _downloadVideo() async {
      Directory? downloadsDirectory = await getExternalStorageDirectory();
      String basePath = '${downloadsDirectory?.path}/lilac/downloads';
      await Directory(basePath).create(recursive: true); // Ensure directory exists
      String videoPath = '$basePath/${videoId}.mp4';
      final http.Response response = await http.get(Uri.parse(videoUrl));
      final File videoFile = File(videoPath);
      await videoFile.writeAsBytes(response.bodyBytes);

    }

  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  void _openLeftDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }
  void _openRightDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void initState() {
 context.read<HomeBloc>().add(HomeFetchVideo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SettingsDrawer(),
      endDrawer: ProfileDrawer(user: widget.user),
      body: SafeArea(
        child: BlocConsumer<HomeBloc,HomeState>(builder: (context, state) {

          if(state is HomeLoading){
            return const Loader();
          }
          if (state is HomeSuccess) {
            print(state.success["url"]);
            return Container(
              height: height,
              width: width,
              color: Theme.of(context).primaryColor,
              child: Column(
                children: [
                  Stack(
                    children: [
                      BlocBuilder<VideoIndexBloc,int>(builder: (context, index) {
                        print(index);
                        print("@!!!!!!!!!!!!!!!!!!!!");

                        if(state.success["url"]!.isNotEmpty){
                          return  SizedBox(
                            width: width,
                            height: height * 0.3,
                            child: VideoPlayerWidget(videoUrl:"https://drive.google.com/uc?export=view&id=${state.success["id"]![index]}",key:  UniqueKey(),),
                          );
                        }
                        else{
                          return  SizedBox(
                            width: width,
                            height: height * 0.3,
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        }

                      },),

                      Positioned(
                        top: height * 0.02,
                        right: width * 0.05,
                        child: GestureDetector(
                          onTap: () => _openRightDrawer(),
                          child: Container(
                            width: width * 0.1,
                            height: width * 0.1,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        widget.user.imageUrl),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(width * 0.02)),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.02,
                        left: width * 0.05,
                        child: GestureDetector(
                          onTap: () => _openLeftDrawer(),
                          child: Container(
                            width: width * 0.07,
                            height: width * 0.07,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage("assets/drawerIcon.png")),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<VideoIndexBloc,int>(builder: (context, index) {
                   return Container(
                      width: width,
                      height: height*0.08,
                      color: Theme.of(context).highlightColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if(index==0){
                                int newIndex=state.success["url"]!.length-1;
                                context.read<VideoIndexBloc>().add(ChangeIndex(index: newIndex));
                              }
                              else{
                                int newIndex=index-1;
                                context.read<VideoIndexBloc>().add(ChangeIndex(index: newIndex));
                              }
                            },
                            child: Container(
                              width: width * 0.1,
                              height: width * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(width*0.0265),
                                  border: Border.all(color: Theme.of(context).hintColor)
                              ),
                              child: const Center(child: Icon(CupertinoIcons.back)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _downloadVideo(state.success["id"]![index], "https://drive.google.com/uc?export=view&id=${state.success["id"]![index]}");
                            },
                            child: Container(
                              width: width * 0.4,
                              height: width * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(width*0.0265),
                                  border: Border.all(color: Theme.of(context).hintColor)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_drop_down,color: Color(0xFFA0C129),size: width*0.08,),

                                  Text("Download",style: TextStyle(fontSize: width*0.045),)
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              int newIndex=(index+1)%(state.success["url"]!.length);
                              context.read<VideoIndexBloc>().add(ChangeIndex(index: newIndex));
                            },
                            child: Container(
                              width: width * 0.1,
                              height: width * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(width*0.0265),
                                  border: Border.all(color: Theme.of(context).hintColor)
                              ),
                              child: const Center(child: Icon(CupertinoIcons.forward)),
                            ),
                          )
                        ],
                      ),
                    );
                  },),
                  SizedBox(
                    height: height*0.02,
                  ),
                  Row(
                    children: [
                      SizedBox(width: width*0.03,),
                      Text("Videos",style: TextStyle(fontSize: width*0.06),),
                    ],
                  ),
                  SizedBox(
                    height: height*0.02,
                  ),
                  const Divider(thickness: 4,),
                  SizedBox(
                    width: width,
                    height: height*0.47,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.success['id']!.length,
                      itemBuilder: (context, index1) {
                      return VideoViewWidget(name:state.success['name']![index1], url: "https://drive.google.com/uc?export=view&id=${state.success["id"]![index1]}" ,key:  UniqueKey(),index: index1,);
                    },),
                  )


                ],
              ),
            );
          }
          else{
            return Container();
          }

        }, listener: (context, state) {
          if (state is HomeFailure) {
            showSnackBar(context, state.message);
          }
        },),

      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lilac_task/features/auth/data/model/user_data_model.dart';

class ProfileDrawer extends StatefulWidget {
  final UserDataModel user;
  const ProfileDrawer({super.key,required this.user});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return SafeArea(
      child: Drawer(
        width: width*0.7,
        child: Column(
          children: [
            SizedBox(
              height: height*0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hello ",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width*0.06
                ),),
                Text("${widget.user.name} !",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width*0.06
                ),),
              ],
            ),
            SizedBox(
              height: height*0.02,
            ),
            Container(
              width: width*0.32,
              height:width*0.32,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(width*0.16,

              ),
                gradient: LinearGradient(colors: [Color(0xFF26BCB1),Color(0xFFA0C129)])
              ),
              child: Center(
                child: Container(
                 width: width*0.3,
                  height:width*0.3,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(width*0.15,
                  ),
                    image: DecorationImage(image: CachedNetworkImageProvider(widget.user.imageUrl,),fit: BoxFit.fill)
                  ),

                ),
              ),
            ),
            SizedBox(
              height: height*0.02,
            ),
            Text(widget.user.email,style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width*0.05
            ),),
            SizedBox(
              height: height*0.02,
            ),Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("🎉 ",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width*0.05
                ),),
                Text(widget.user.dob,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width*0.05
                ),),
              ],
            ),
            SizedBox(
              height: height*0.02,
            ),Text(widget.user.phoneNo,style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width*0.05
            ),),
            SizedBox(
              height: height*0.02,
            ),



          ],
        ),
      ),
    );
  }
}

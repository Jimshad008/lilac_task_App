import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lilac_task/core/constant/theme_bool/bloc/theme_bool_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constant/global constant.dart';
import '../../../../core/utils/logout_alert.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({super.key});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {


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
            Text("Settings",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width*0.06
            ),),
            SizedBox(
              height: height*0.02,
            ),
            const Divider(
              thickness: 2,
            ),
            SizedBox(
              height: height*0.02,
            ),
            Padding(
              padding:  EdgeInsets.only(left: width*0.03,right: width*0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Theme",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width*0.04
                  ),),
                  BlocBuilder<ThemeBoolBloc,bool>(builder: (context, state) {
                   return AdvancedSwitch(
                      width: width*0.17,
                      initialValue: state,
                      onChanged: (value) async {

                        final SharedPreferences local=await SharedPreferences.getInstance();
                        local.setBool("theme", value);
                        context.read<ThemeBoolBloc>().add(ThemeBoolChange(theme: value));
                      },
                      inactiveChild: Icon(Icons.dark_mode),
                      activeChild: Icon(Icons.light_mode),
                    );
                  },),

                ],
              ),
            ),
            SizedBox(
              height: height*0.02,
            ),
            const Divider(
              thickness: 2,
            ),
            SizedBox(
              height: height*0.02,
            ),
            Padding(
              padding:  EdgeInsets.only(left: width*0.03,right: width*0.03),
              child: GestureDetector(
                onTap: () {
                  showLogoutDialog(context);
                },
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Logout",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width*0.04
                      ),),
                      Icon(Icons.logout)

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height*0.02,
            ),
            const Divider(
              thickness: 2,
            ),
          ],
        ),


      ),
    );
  }
}

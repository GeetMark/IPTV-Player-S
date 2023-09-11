import 'package:flutter/material.dart';
import 'package:iptvplayer/l10n/localization.dart';
import 'package:iptvplayer/pages/add_new_iptv.dart';
import 'package:iptvplayer/pages/player_screen.dart';
import 'package:iptvplayer/pages/search_channel_delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:iptvplayer/utils/modal_channel_info.dart';




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChannelInfo> favoriteChannels = [];
  List<ChannelInfo> filteredChannels = [];
  TextEditingController searchController = TextEditingController();

  Map<String, List<ChannelInfo>> groupedChannels = {};

  @override
  void initState() {
    super.initState();
   // Wakelock.enable();
    _loadFavoriteChannels();
  }

  Future<void> _loadFavoriteChannels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String channelsJson = prefs.getString('channelsJson') ?? '[]';
    List<dynamic> channelJsonList = jsonDecode(channelsJson);

    setState(() {
      favoriteChannels = channelJsonList.map((json) => ChannelInfo.fromJson(json)).toList();
      filteredChannels = favoriteChannels;
      groupedChannels = _groupChannelsByCategory(filteredChannels);
    });
  }

  Map<String, List<ChannelInfo>> _groupChannelsByCategory(List<ChannelInfo> channels) {
    Map<String, List<ChannelInfo>> groupedMap = {};

    for (var channel in channels) {
      if (!groupedMap.containsKey(channel.category)) {
        groupedMap[channel.category] = [];
      }
      groupedMap[channel.category]!.add(channel);
    }

    return groupedMap;
  }

  @override
  Widget build(BuildContext context) {
    if (groupedChannels.isNotEmpty) {
      return DefaultTabController(
        length: groupedChannels.keys.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "IPTV Player S",
              style: TextStyle(
                fontSize: 25,       // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Add bold weight
                color: Colors.white,
                //fontStyle: FontStyle.italic,

              ),
            ),
           // backgroundColor: Colors.blue[900],
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: ChannelSearchDelegate(filteredChannels));
                },
                icon: Icon(Icons.search),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: TabBar(
                isScrollable: true,
                tabs: groupedChannels.keys.map((category)  {
                  return Tab(text: category);
                }).toList(),
              ),
            ),
          ),
          body: Container( // Wrap the body content in a Container
            color: Colors.cyan.shade50,
            child:TabBarView(
            children: groupedChannels.keys.map((category) {
              List<ChannelInfo> channelsInCategory = groupedChannels[category]!;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2.4 / 3,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                ),
                itemCount: channelsInCategory.length,
                itemBuilder: (context, index) {
                  ChannelInfo channel = channelsInCategory[index];
                  return InkWell(
                    onTap: () {

                      showGeneralDialog(
                        barrierLabel: "page_key",
                        barrierDismissible: false,
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionDuration: Duration(milliseconds: 200),
                        context: context,
                        pageBuilder: (context, anim1, anim2) {
                          return VideoPlayerScreen(videoUrl: channel.url, title: channel.title, category: channel.category, image: channel.image);
                        },
                        transitionBuilder: (context, anim1, anim2, child) {
                          return SlideTransition(
                            position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
                            child: child,
                          );
                        },
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 90,
                            child: channel.image?.isNotEmpty ?? false
                                ? Image.network(
                              channel.image!,
                              fit: BoxFit.contain,
                            )
                                : Image.asset(
                              'assets/images/empty.png',
                              fit: BoxFit.cover,
                            ),

                          ),
                          SizedBox(height: 4),
                          Text(
                            channel.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            channel.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            ) ,
          ) ,
        ),
      );
    }else
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "IPTV Player S",
            style: TextStyle(
              fontSize: 25,       // Adjust the font size as needed
              fontWeight: FontWeight.bold, // Add bold weight
              color: Colors.white,
              //fontStyle: FontStyle.italic,

            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Handle search action here
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
        body: Container(
    color: Colors.cyan.shade50,
    child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                 Localization.get("Providers"),
                style: TextStyle(fontSize: 25,color: Colors.black),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  Localization.get("You_haven_added_IPTV_provider"),
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNewIptv()),
                  );
                },
                child: Text(Localization.get("Import_M3U_File")),
              ),
            ],
          ),
         ),
        ),
      );


  }
}

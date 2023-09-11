import 'package:flutter/material.dart';
import 'package:iptvplayer/l10n/localization.dart';
import 'package:iptvplayer/pages/add_new_iptv.dart';
import 'package:iptvplayer/pages/player_screen.dart';
import 'package:iptvplayer/pages/search_channel_delegate.dart';
import 'package:iptvplayer/utils/modal_channel_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Channel> channels = [];

  @override
  void initState() {
    super.initState();
    loadChannels().then((loadedChannels) {
      setState(() {
        channels = loadedChannels;
      });
    });
  }

  Future<List<Channel>> loadChannels() async {
    final prefs = await SharedPreferences.getInstance();
    final channelList = prefs.getStringList('channels') ?? [];
    print('Loaded channels: $channelList');
    return channelList.map((channelString) {
      final parts = channelString.split(',');
      return Channel(
        url: parts[0],
        title: parts[1],
        category: parts[2],
        image: parts[3],
      );
    }).toList();
  }

  void _removeItem(int index) async {
    Channel channelToRemove = channels[index];
    setState(() {
      channels.removeAt(index);
    });

    List<String> channelStrings = channels.map((channel) {
      return "${channel.url},${channel.title},${channel.category},${channel.image}";
    }).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('channels', channelStrings);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item removed successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    if (channels.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(Localization.get("Favorite_Channels")),
         /* actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: ChannelSearchDelegate(channels.cast<ChannelInfo>()));
              },
              icon: Icon(Icons.search),
            ),
          ],*/
        ),
        body: Container(
          color: Colors.cyan.shade50,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2.4 / 3,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemCount: channels.length,
            itemBuilder: (context, index) {
              Channel channel = channels[index];
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
                 /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(videoUrl: channel.url, title: channel.title, category: channel.category, image: channel.image),
                    ),
                  );*/
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
                        width: 100,
                        height: 40,
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
                      /*  SizedBox(height: 8),
                    IconButton(
                      onPressed: () {
                        _removeItem(index);
                      },
                      icon: Icon(Icons.bookmark_remove,color: Colors.black54,),
                    ),*/
                      SizedBox(height: 2),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'remove') {
                            _removeItem(index);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'remove',
                              child: Text(Localization.get("Remove")),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

    }else

      return Scaffold(
        appBar: AppBar(
          title: Text(Localization.get("Favorite_Channels")),
        ),
        body: Container(
    color: Colors.cyan.shade50,
    child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Localization.get("Favorite"),
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

class Channel {
  String url;
  String title;
  String category;
  String image;

  Channel({required this.url, required this.title, required this.category, required this.image});
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iptvplayer/utils/ads.dart';
import 'package:iptvplayer/utils/modal_channel_info.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:wakelock_plus/wakelock_plus.dart';



class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String category;
  final String image;

  VideoPlayerScreen({required this.videoUrl, required this.title, required this.category, required this.image});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  List<ChannelInfo> favoriteChannels = [];
  bool isVideoPlaying = false;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();


    _loadFavoriteChannels();
   // _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        if (_videoPlayerController.value.isPlaying) {
          setState(() {
            isVideoPlaying = true;
          });
        }
      });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    Ads.initialize();
  }



  @override
  void dispose() {

    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }
/*
  Future<void> _loadFavoriteChannels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String channelsJson = prefs.getString('channelsJson') ?? '[]';
    List<dynamic> channelJsonList = jsonDecode(channelsJson);

    setState(() {
      favoriteChannels = channelJsonList.map((json) => ChannelInfo.fromJson(json)).toList();
    });
  }*/

  Future<void> _loadFavoriteChannels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String channelsJson = prefs.getString('channelsJson') ?? '[]';
    List<dynamic> channelJsonList = jsonDecode(channelsJson);

    setState(() {
      favoriteChannels = channelJsonList
          .map((json) => ChannelInfo.fromJson(json))
          .where((channel) => channel.category == widget.category)
          .toList();
    });
  }


  void saveChannels(String url, String title, String category, String image) async {
    final prefs = await SharedPreferences.getInstance();
    final channelList = prefs.getStringList('channels') ?? [];
    final channelString = "$url,$title,$category,$image";
    channelList.add(channelString);
    await prefs.setStringList('channels', channelList);
  }


  void saveChannelsF() {
    saveChannels(widget.title, widget.title, widget.category, widget.image);
    setState(() {
      isSaved = !isSaved;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.vertical,
      key: const Key('page_key'),
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        body: Container(
          color: Colors.grey[900],
          child: Column(
            children: [
              // Video player section
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    ),
                    if (!isVideoPlaying)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
             /* Container(
                height: 50,

                decoration: BoxDecoration(
                  color: Colors.grey[50],
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.bookmark_add),
                              onPressed: () {
                                saveChannels(widget.title,widget.title,widget.category,widget.image);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                                // Handle share button press
                              },
                            ),

                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),*/
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            style: TextStyle(fontSize: 15, color: Colors.black87),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                            color: isSaved ? Colors.blue : Colors.black45,
                          ),
                          onPressed: saveChannelsF,
                        ),
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.black45),
                          onPressed: () {
                            // Handle share button press
                          },
                        ),
                      ],
                    ),
                  ],

                ),

              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    if (Ads.getBannerAdWidget() != null)
                      Ads.getBannerAdWidget()!,
                  ],
                ),
              ),

              // List of favorite channels (show only 10)
              Container(
                height: 130,
                color: Colors.grey[700],
                child:  GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  itemCount: favoriteChannels.length >= 100 ? 100 : favoriteChannels.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoUrl: favoriteChannels[index].url,
                                title: favoriteChannels[index].title,
                                category: favoriteChannels[index].category,
                                image: favoriteChannels[index].image,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 70,
                              child: favoriteChannels[index].image?.isNotEmpty ?? false
                                  ? Image.network(
                                favoriteChannels[index].image!,
                                fit: BoxFit.contain,
                              )
                                  : Image.asset(
                                'assets/images/empty.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Channel title
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                favoriteChannels[index].title,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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

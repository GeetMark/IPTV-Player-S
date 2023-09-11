import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              saveChannels(widget.title,widget.title,widget.category,widget.image);
            },
            icon: Icon(Icons.bookmark_add,color: Colors.white70,),
          ),
        ],
        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            // Video player
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
            if (Ads.bannerAd != null)
              Container(
                width: Ads.bannerAd!.size.width.toDouble(),
                height: Ads.bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: Ads.bannerAd!),
              ),
            // List of favorite channels (show only 10)
            Container(
              height: 300,
              color: Colors.grey[700],


              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: favoriteChannels.length >= 100 ? 100 : favoriteChannels.length, // Show up to 10 items
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(

                            builder: (context) => VideoPlayerScreen(videoUrl: favoriteChannels[index].url, title: favoriteChannels[index].title, category: favoriteChannels[index].category, image: favoriteChannels[index].image),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150, // Fixed width
                            height: 90, // Fixed height
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
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
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

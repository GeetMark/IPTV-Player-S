
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iptvplayer/l10n/localization.dart';
import 'package:iptvplayer/navbar/curved_navigation_bar.dart';
import 'package:iptvplayer/pages/add_new_iptv.dart';
import 'package:iptvplayer/pages/home.dart';
import 'package:iptvplayer/utils/modal_channel_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListIptvPage extends StatefulWidget {
  @override
  _ListIptvPageState createState() => _ListIptvPageState();
}

class _ListIptvPageState extends State<ListIptvPage> {
  List<String> iptvList = [];
  int selectedCardIndex = -1;
  List<ChannelInfo> channels = [];
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _loadIptvList();
    configLoading();
  }

  Future<void> _loadIptvList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> loadedList = prefs.getStringList('iptvList') ?? [];
    setState(() {
      iptvList = loadedList;
    });
  }

  void configLoading() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..backgroundColor = Colors.black.withOpacity(0.7)
      ..textColor = Colors.white
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false;
  }

  Future<void> fetchChannels(String mUrl) async {
    try {
      EasyLoading.show(status: Localization.get("Loading"));

      final response = await http.get(Uri.parse(mUrl));
      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);
        final lines = LineSplitter.split(decodedResponse).toList(); // Convert to a List

        final channelJsonList = <ChannelInfo>[];

        for (int i = 0; i < lines.length; i++) {
          final line = lines[i];
          if (line.startsWith('#EXTINF:')) {
            final streamLine = lines[i + 1];
            final channel = ChannelInfo.fromM3U(line, streamLine);
            channelJsonList.add(channel);
          }
        }

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('channelsJson', jsonEncode(channelJsonList));

        setState(() {
          channels = channelJsonList;
        });

        EasyLoading.showSuccess(Localization.get("Channels_saved_successfully"));
        /*final CurvedNavigationBarState? navBarState =
            _bottomNavigationKey.currentState;
        navBarState?.setPage(0);*/

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        EasyLoading.showError(Localization.get("Failed_to_fetch_channels"));
      }
    } catch (e) {
      EasyLoading.showError(Localization.get("An_error_occurred")+': $e');
    } finally {
      EasyLoading.dismiss();
    }
  }




/*
  Future<void> fetchChannels(String mUrl) async {
    final response = await http.get(Uri.parse(mUrl));

    if (response.statusCode == 200) {
      String responseBody = response.body;
      String decodedResponse = utf8.decode(responseBody.codeUnits);
      final lines = decodedResponse.split('\n');
      print("......................lines ;.......${lines.length}");
      int lLength = 50000;
      if (lines.length > lLength) {
        // If there are more than 1000 lines, process only the first 1000 lines
        print("Too many lines to process. Processing only the first $lLength lines.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You have ${lines.length} lines. Too many lines to process. Processing only the first $lLength lines."),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.yellow[900],
            behavior: SnackBarBehavior.floating,
          ),
        );

        lines.removeRange(lLength, lines.length); // Remove lines beyond 1000
      }
      final filteredLines = lines.where((line) => line.startsWith('#EXTINF:')).toList();

      setState(()  async {
        channels = filteredLines.map((line) {
          final streamLine = lines[lines.indexOf(line) + 1];
          return ChannelInfo.fromM3U(line, streamLine);
        }).toList();
        List<Map<String, dynamic>> channelJsonList =
        channels.map((channel) => channel.toJson()).toList();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('channelsJson', jsonEncode(channelJsonList));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Channels saved successfully!'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        final CurvedNavigationBarState? navBarState =
            _bottomNavigationKey.currentState;
        navBarState?.setPage(0);
      });
    } else {
      print('Failed to fetch channels');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch channels'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    if (iptvList.isNotEmpty) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.get("IPTV_List")),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNewIptv()),
              ).then((value) {
                _loadIptvList();
              });
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.cyan.shade50,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: iptvList.length,
                  itemBuilder: (context, index) {
                    String entry = iptvList[index];
                    List<String> entryParts = entry.split('|');
                    String name = entryParts[0];
                    String urlType = entryParts[1];
                    String url = entryParts[2];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCardIndex = index;
                          fetchChannels(url);
                        });
                        print('Selected: $name');
                      },
                      child: Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        color: selectedCardIndex == index ? Colors.blue : null,
                        child: ListTile(
                          leading: Icon(Icons.live_tv),
                          title: Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(url),
                          trailing: PopupMenuButton<String>(
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
    }else
      return Scaffold(
        appBar: AppBar(
          title: Text(Localization.get("IPTV_List")),
        ),
        body: Container(
          color: Colors.cyan.shade50,
          child:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Localization.get("IPTV_List"),
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

  void _removeItem(int index) async {
    setState(() {
      iptvList.removeAt(index);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('iptvList', iptvList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(Localization.get("Item_removed_successfully")),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

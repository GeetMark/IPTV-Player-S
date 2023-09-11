
import 'package:flutter/material.dart';
import 'package:iptvplayer/pages/player_screen.dart';
import 'package:iptvplayer/utils/modal_channel_info.dart';

class ChannelSearchDelegate extends SearchDelegate<ChannelInfo?> {
  final List<ChannelInfo> channels;

  ChannelSearchDelegate(this.channels);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<ChannelInfo> filteredResults = channels.where((channel) {
      return channel.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2.4 / 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        ChannelInfo channel = filteredResults[index];
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
                builder: (context) => VideoPlayerScreen(videoUrl: channel.url,title: channel.title,category: channel.category, image: channel.image),
              ),
            );*/
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 4, // Shadow elevation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity, // Expand to the available width
                  height: 100, // Fixed height
                  child: channel.image?.isNotEmpty ?? false
                      ? Image.network(
                    channel.image!,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/empty.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  channel.category,
                  maxLines: 2, // Display only 2 lines for the title
                  overflow: TextOverflow.ellipsis, // Handle overflow
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                Text(
                  channel.title,
                  maxLines: 2, // Display only 2 lines for the title
                  overflow: TextOverflow.ellipsis, // Handle overflow
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

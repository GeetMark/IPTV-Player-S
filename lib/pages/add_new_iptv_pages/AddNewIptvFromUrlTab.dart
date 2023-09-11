import 'package:flutter/material.dart';
import 'package:iptvplayer/pages/home.dart';
import 'package:iptvplayer/utils/modal_channel_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddNewIptv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New IPTV'),
      ),
      body: AddNewIptvForm(),
    );
  }
}

class AddNewIptvForm extends StatefulWidget {
  @override
  _AddNewIptvFormState createState() => _AddNewIptvFormState();
}

class _AddNewIptvFormState extends State<AddNewIptvForm> {
  String urlType = 'M3U';
  TextEditingController nameController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  List<ChannelInfo> channels = [];

  void _loadSavedIptvList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> iptvList = prefs.getStringList('iptvList') ?? [];
  }

  void _addNewIptv() async {
    String name = nameController.text;
    String url = urlController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> iptvList = prefs.getStringList('iptvList') ?? [];

    iptvList.add('$name|$urlType|$url');
    await prefs.setStringList('iptvList', iptvList);

    // Reset the text fields
    nameController.clear();
    urlController.clear();

    // Call fetchChannels here after adding IPTV
    await fetchChannels(url);

    // Close the current page
    Navigator.pop(context);
  }

  Future<void> fetchChannels(String mUrl) async {
    final response = await http.get(Uri.parse(mUrl));

    if (response.statusCode == 200) {
      final lines = response.body.split('\n');
      final filteredLines = lines.where((line) => line.startsWith('#EXTINF:')).toList();

      setState(() async {
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
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: urlController,
            decoration: InputDecoration(labelText: 'URL'),
          ),
          SizedBox(height: 16.0),
          DropdownButton<String>(
            value: urlType,
            onChanged: (newValue) {
              setState(() {
                urlType = newValue!;
              });
            },
            items: ['M3U', 'M3U8'].map<DropdownMenuItem<String>>(
                  (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _addNewIptv,
            child: Text('Add New URL'),
          ),
          SizedBox(height: 16.0),
          GridView.count(
            crossAxisCount: 3, // Number of columns in the grid
            shrinkWrap: true,
            children: [
              _buildMenuItem('Add New IPTV from URL', Icons.link, () {
                // Implement the action for this menu item
              }),
              _buildMenuItem('IPTV from TEXT', Icons.text_fields, () {
                // Implement the action for this menu item
              }),
              _buildMenuItem('IPTV from Storage', Icons.storage, () {
                // Implement the action for this menu item
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(icon, size: 40.0),
          SizedBox(height: 8.0),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

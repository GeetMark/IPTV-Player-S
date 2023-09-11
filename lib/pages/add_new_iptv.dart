import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iptvplayer/l10n/localization.dart';
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
        title: Text(Localization.get("Add_New_IPTV")),

      ),
      body: Container(
        color: Colors.blueGrey[50], // Set your desired background color here
        child: AddNewIptvForm(),
      ),
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
  TextEditingController name2Controller = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController url2Controller = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  List<ChannelInfo> channels = [];
  bool _obscureText = true;


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

  void _addNewIptv2() async {
    String name2 = name2Controller.text;
    String url2 = url2Controller.text;
    String password = passwordController.text;
    String username = usernameController.text;
    String mUrl = url2+"/get.php?username="+username+"&password="+password+"type=m3u_plus";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> iptvList = prefs.getStringList('iptvList') ?? [];

    iptvList.add('$name2|$urlType|$mUrl');
    await prefs.setStringList('iptvList', iptvList);

    // Reset the text fields
    name2Controller.clear();
    url2Controller.clear();
    passwordController.clear();
    usernameController.clear();

    await fetchChannels(mUrl);

    Navigator.pop(context);
  }
/*
  Future<void> fetchChannels(String mUrl) async {
    final response = await http.get(Uri.parse(mUrl));

    if (response.statusCode == 200) {
      _textm3u(response.body);
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
*/

  void _textm3u(String inputText) {
    String responseBody = inputText;
    String decodedResponse = utf8.decode(responseBody.codeUnits);
    final lines = decodedResponse.split('\n');
    print("......................lines ;.......${lines.length}");
    /*int lLength = 50000;
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
    }*/
    final filteredLines = lines.where((line) => line.startsWith('#EXTINF:')).toList();

    List<ChannelInfo> newChannels = filteredLines.map((line) {
      final streamLine = lines[lines.indexOf(line) + 1];
      return ChannelInfo.fromM3U(line, streamLine);
    }).toList();

    _updateChannels(newChannels);
  }



  void _updateChannels(List<ChannelInfo> newChannels) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> channelJsonList =
    newChannels.map((channel) => channel.toJson()).toList();
    await prefs.setString('channelsJson', jsonEncode(channelJsonList));

    setState(() {
      channels = newChannels;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(Localization.get("Channels_saved_successfully")),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
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


        EasyLoading.showSuccess(Localization.get("Channels_saved_successfully") );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            children: [
              _buildMenuItemCard(Localization.get("Add_New_IPTV_from_URL"), Icons.link, () {
                _showIptvFromURLDialog(context);
              }),
              _buildMenuItemCard(Localization.get("IPTV_from_TEXT"), Icons.text_fields, () {
                _showIptvFromTEXTDialog(context);
              }),
              _buildMenuItemCard(Localization.get("Import_m3u_with_username_and_password"), Icons.storage, () {
                _showIptvFromStorageDialog(context);
              }),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildMenuItemCard(String title, IconData icon, VoidCallback onPressed) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40.0),
              SizedBox(height: 8.0),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  void _showIptvFromURLDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Localization.get("Add_New_IPTV")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: Localization.get("Name")),
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
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(Localization.get("Cancel")),
            ),
            ElevatedButton(
              onPressed: () {
                _addNewIptv();
                Navigator.pop(context); // Close the dialog
              },
              child: Text(Localization.get("Add")),
            ),
          ],
        );
      } ,
    );
  }



  void _showIptvFromTEXTDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Localization.get("IPTV_from_TEXT")),
          content: Container(
            constraints: BoxConstraints(maxHeight: 400), // Set a maximum height
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    maxLines: null,
                    decoration: InputDecoration(labelText: Localization.get("IPTV_Text")),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(Localization.get("Cancel")),
            ),
            ElevatedButton(
              onPressed: () {
                _textm3u(textController.text);
                Navigator.pop(context); // Close the dialog
              },
              child: Text(Localization.get("Add")),
            ),
          ],
        );
      },
    );
  }

  void _showIptvFromStorageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Localization.get("Add_New_IPTV")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: name2Controller,
                  decoration: InputDecoration(labelText: Localization.get("Name")),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText:  Localization.get("Username")),
                ),

                SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText:  Localization.get("Password"),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Toggle password visibility
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscureText,
                ),

                SizedBox(height: 16.0),
                TextFormField(
                  controller: url2Controller,
                  decoration: InputDecoration(labelText: 'URL'),
                ),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(Localization.get("Cancel")),
            ),
            ElevatedButton(
              onPressed: () {
                _addNewIptv2();
                Navigator.pop(context); // Close the dialog
              },
              child: Text(Localization.get("Add")),
            ),
          ],
        );
      } ,
    );
  }

}

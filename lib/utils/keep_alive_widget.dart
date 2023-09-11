import 'package:flutter/material.dart';
import 'package:iptvplayer/pages/player_screen.dart';


class KeepAliveWidget extends StatefulWidget {
  final VideoPlayerScreen parent;

  const KeepAliveWidget({required this.parent});

  @override
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin<KeepAliveWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return widget.parent;
  }
}



import 'dart:convert';

class ChannelInfo {
  final String id;
  final String image;
  final String category;
  final String title;
  final String url;

  ChannelInfo({
    required this.id,
    required this.image,
    required this.category,
    required this.title,
    required this.url,
  });

  factory ChannelInfo.fromJson(Map<String, dynamic> json) {
    return ChannelInfo(
      id: json['id'],
      image: json['image'],
      category: json['category'],
      title: json['title'],
      url: json['url'],
    );
  }

  factory ChannelInfo.fromM3U2(String m3uLine, String streamLine) {
    final id = RegExp(r'tvg-id="([^"]*)"').firstMatch(m3uLine)?.group(1) ?? 'Id X';
    final image = RegExp(r'tvg-logo="([^"]*)"').firstMatch(m3uLine)?.group(1) ?? '';
    final category = RegExp(r'group-title="([^"]*)"').firstMatch(m3uLine)?.group(1) ?? 'category X';
    final title = RegExp(r',(.+)').firstMatch(m3uLine)?.group(1)?.trim() ?? 'Channe X';

    return ChannelInfo(
      id: id,
      image: image,
      category: category,
      title: title,
      url: streamLine.trim(),
    );
  }



  factory ChannelInfo.fromM3U(String m3uLine, String streamLine) {
    final idMatch = RegExp(r'tvg-id="([^"]*)"').firstMatch(m3uLine);
    final id = idMatch?.group(1) ?? 'Id X';

    final imageMatch = RegExp(r'tvg-logo="([^"]*)"').firstMatch(m3uLine);
    final image = imageMatch?.group(1) ?? '';

    final categoryMatch = RegExp(r'group-title="([^"]*)"').firstMatch(m3uLine);
    final category = categoryMatch?.group(1) ?? 'category X';


    final titleMatch = RegExp(r'group-title="[^"]*",(.+)').firstMatch(m3uLine);
    var title = titleMatch?.group(1) ?? 'Channe X';
        title = title.trim();
    return ChannelInfo(
      id: id,
      image: image,
      category: category,
      title: title,
      url: streamLine.trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'category': category,
      'title': title,
      'url': url,
    };
  }
}
class IPTVConverter {
  String base_url;

  IPTVConverter(this.base_url);

  String macToM3uUrl(String macAddress) {
    String macParts = macAddress.replaceAll(":", "").toUpperCase();
    String m3uUrl = "$base_url/$macParts.m3u";
    return m3uUrl;
  }
}

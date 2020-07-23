class LskyConfig {
  String host;
  String token;

  LskyConfig({this.host, this.token});

  LskyConfig.fromJson(Map<String, dynamic> json) {
    host = json['host'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['host'] = this.host;
    data['token'] = this.token;
    return data;
  }
}

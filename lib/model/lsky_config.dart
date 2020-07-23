class LskyConfig {
  String host;
  String email;
  String password;
  String token;

  LskyConfig({this.host, this.email, this.password, this.token});

  LskyConfig.fromJson(Map<String, dynamic> json) {
    host = json['host'];
    email = json['email'];
    password = json['password'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['host'] = this.host;
    data['email'] = this.email;
    data['password'] = this.password;
    data['token'] = this.token;
    return data;
  }
}

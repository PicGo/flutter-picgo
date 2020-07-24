class UpyunConfig {
  String bucket;
  String operator;
  String options;
  String password;
  String path;
  String url;

  UpyunConfig(
      {this.bucket,
      this.operator,
      this.options,
      this.password,
      this.path,
      this.url});

  UpyunConfig.fromJson(Map<String, dynamic> json) {
    bucket = json['bucket'];
    operator = json['operator'];
    options = json['options'];
    password = json['password'];
    path = json['path'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bucket'] = this.bucket;
    data['operator'] = this.operator;
    data['options'] = this.options;
    data['password'] = this.password;
    data['path'] = this.path;
    data['url'] = this.url;
    return data;
  }
}

class TcyunConfig {
  String appId;
  String area;
  String bucket;
  String customUrl;
  String path;
  String secretId;
  String secretKey;

  TcyunConfig(
      {this.appId,
      this.area,
      this.bucket,
      this.customUrl,
      this.path,
      this.secretId,
      this.secretKey});

  TcyunConfig.fromJson(Map<String, dynamic> json) {
    appId = json['appId'];
    area = json['area'];
    bucket = json['bucket'];
    customUrl = json['customUrl'];
    path = json['path'];
    secretId = json['secretId'];
    secretKey = json['secretKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appId'] = this.appId;
    data['area'] = this.area;
    data['bucket'] = this.bucket;
    data['customUrl'] = this.customUrl;
    data['path'] = this.path;
    data['secretId'] = this.secretId;
    data['secretKey'] = this.secretKey;
    return data;
  }
}
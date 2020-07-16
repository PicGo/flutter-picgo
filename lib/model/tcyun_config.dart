class TcyunConfig {
  String area;
  String bucket;
  String customUrl;
  String path;
  String secretId;
  String secretKey;

  TcyunConfig({
      this.area,
      this.bucket,
      this.customUrl,
      this.path,
      this.secretId,
      this.secretKey});

  TcyunConfig.fromJson(Map<String, dynamic> json) {
    area = json['area'];
    bucket = json['bucket'];
    customUrl = json['customUrl'];
    path = json['path'];
    secretId = json['secretId'];
    secretKey = json['secretKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    data['bucket'] = this.bucket;
    data['customUrl'] = this.customUrl;
    data['path'] = this.path;
    data['secretId'] = this.secretId;
    data['secretKey'] = this.secretKey;
    return data;
  }
}
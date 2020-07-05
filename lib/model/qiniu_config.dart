class QiniuConfig {
  String accessKey;
  String area;
  String bucket;
  String options;
  String path;
  String secretKey;
  String url;

  QiniuConfig(
      {this.accessKey,
      this.area,
      this.bucket,
      this.options,
      this.path,
      this.secretKey,
      this.url});

  QiniuConfig.fromJson(Map<String, dynamic> json) {
    accessKey = json['accessKey'];
    area = json['area'];
    bucket = json['bucket'];
    options = json['options'];
    path = json['path'];
    secretKey = json['secretKey'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessKey'] = this.accessKey;
    data['area'] = this.area;
    data['bucket'] = this.bucket;
    data['options'] = this.options;
    data['path'] = this.path;
    data['secretKey'] = this.secretKey;
    data['url'] = this.url;
    return data;
  }
}
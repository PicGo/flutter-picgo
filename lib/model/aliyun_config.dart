class AliyunConfig {
  String accessKeyId;
  String accessKeySecret;
  String area;
  String bucket;
  String customUrl;
  String options;
  String path;

  AliyunConfig(
      {this.accessKeyId,
      this.accessKeySecret,
      this.area,
      this.bucket,
      this.customUrl,
      this.options,
      this.path});

  AliyunConfig.fromJson(Map<String, dynamic> json) {
    accessKeyId = json['accessKeyId'];
    accessKeySecret = json['accessKeySecret'];
    area = json['area'];
    bucket = json['bucket'];
    customUrl = json['customUrl'];
    options = json['options'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessKeyId'] = this.accessKeyId;
    data['accessKeySecret'] = this.accessKeySecret;
    data['area'] = this.area;
    data['bucket'] = this.bucket;
    data['customUrl'] = this.customUrl;
    data['options'] = this.options;
    data['path'] = this.path;
    return data;
  }
}

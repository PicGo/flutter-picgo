class LskyContent {
  int id;
  String strategy;
  String path;
  String name;
  Null aliasName;
  String pathname;
  String size;
  String mime;
  String sha1;
  String md5;
  String ip;
  int suspicious;
  int uploadTime;
  String uploadDate;
  String url;

  LskyContent(
      {this.id,
      this.strategy,
      this.path,
      this.name,
      this.aliasName,
      this.pathname,
      this.size,
      this.mime,
      this.sha1,
      this.md5,
      this.ip,
      this.suspicious,
      this.uploadTime,
      this.uploadDate,
      this.url});

  LskyContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    strategy = json['strategy'];
    path = json['path'];
    name = json['name'];
    aliasName = json['alias_name'];
    pathname = json['pathname'];
    size = json['size'];
    mime = json['mime'];
    sha1 = json['sha1'];
    md5 = json['md5'];
    ip = json['ip'];
    suspicious = json['suspicious'];
    uploadTime = json['upload_time'];
    uploadDate = json['upload_date'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['strategy'] = this.strategy;
    data['path'] = this.path;
    data['name'] = this.name;
    data['alias_name'] = this.aliasName;
    data['pathname'] = this.pathname;
    data['size'] = this.size;
    data['mime'] = this.mime;
    data['sha1'] = this.sha1;
    data['md5'] = this.md5;
    data['ip'] = this.ip;
    data['suspicious'] = this.suspicious;
    data['upload_time'] = this.uploadTime;
    data['upload_date'] = this.uploadDate;
    data['url'] = this.url;
    return data;
  }
}

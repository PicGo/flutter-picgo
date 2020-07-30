class SMMSContent {
  int width;
  int height;
  String filename;
  String storename;
  int size;
  String path;
  String hash;
  int createdAt;
  String url;
  String delete;
  String page;

  SMMSContent(
      {this.width,
      this.height,
      this.filename,
      this.storename,
      this.size,
      this.path,
      this.hash,
      this.createdAt,
      this.url,
      this.delete,
      this.page});

  SMMSContent.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    filename = json['filename'];
    storename = json['storename'];
    size = json['size'];
    path = json['path'];
    hash = json['hash'];
    createdAt = json['created_at'];
    url = json['url'];
    delete = json['delete'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    data['filename'] = this.filename;
    data['storename'] = this.storename;
    data['size'] = this.size;
    data['path'] = this.path;
    data['hash'] = this.hash;
    data['created_at'] = this.createdAt;
    data['url'] = this.url;
    data['delete'] = this.delete;
    data['page'] = this.page;
    return data;
  }
}
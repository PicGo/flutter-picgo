import 'package:flutter_picgo/components/manage_item.dart';

class GithubContent {
  FileContentType type;
  String encoding;
  int size;
  String name;
  String path;
  String content;
  String sha;
  String url;
  String gitUrl;
  String htmlUrl;
  String downloadUrl;

  GithubContent({
    this.type,
    this.encoding,
    this.size,
    this.name,
    this.path,
    this.content,
    this.sha,
    this.url,
    this.gitUrl,
    this.htmlUrl,
    this.downloadUrl,
  });

  GithubContent.fromJson(Map<String, dynamic> json) {
    type = json['type'] == 'file' ? FileContentType.FILE : FileContentType.DIR;
    encoding = json['encoding'];
    size = json['size'];
    name = json['name'];
    path = json['path'];
    content = json['content'];
    sha = json['sha'];
    url = json['url'];
    gitUrl = json['git_url'];
    htmlUrl = json['html_url'];
    downloadUrl = json['download_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type == FileContentType.FILE ? 'file' : 'dir';
    data['encoding'] = this.encoding;
    data['size'] = this.size;
    data['name'] = this.name;
    data['path'] = this.path;
    data['content'] = this.content;
    data['sha'] = this.sha;
    data['url'] = this.url;
    data['git_url'] = this.gitUrl;
    data['html_url'] = this.htmlUrl;
    data['download_url'] = this.downloadUrl;
    return data;
  }
}

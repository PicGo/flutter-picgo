class CodebergConfig {
  String repo;
  String token;
  String branch;
  String path;
  String customUrl;

  CodebergConfig(
      {this.repo, this.token, this.branch, this.path, this.customUrl});

  CodebergConfig.fromJson(Map<String, dynamic> json) {
    repo = json['repo'];
    token = json['token'];
    branch = json['branch'];
    path = json['path'];
    customUrl = json['customUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['repo'] = this.repo;
    data['token'] = this.token;
    data['branch'] = this.branch;
    data['path'] = this.path;
    data['customUrl'] = this.customUrl;
    return data;
  }
}

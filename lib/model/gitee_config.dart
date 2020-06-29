class GiteeConfig {
  String owner;
  String path;
  String repo;
  String token;
  String customUrl;
  String branch;

  GiteeConfig(
      {this.owner,
      this.path,
      this.repo,
      this.token,
      this.customUrl,
      this.branch});

  GiteeConfig.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    path = json['path'];
    repo = json['repo'];
    token = json['token'];
    customUrl = json['customUrl'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['path'] = this.path;
    data['repo'] = this.repo;
    data['token'] = this.token;
    data['customUrl'] = this.customUrl;
    data['branch'] = this.branch;
    return data;
  }
}

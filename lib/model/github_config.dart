class GithubConfig {
  String branch;
  String customUrl;
  String path;
  String repo;
  String token;

  GithubConfig({this.branch, this.customUrl, this.path, this.repo, this.token});

  GithubConfig.fromJson(Map<String, dynamic> json) {
    branch = json['branch'];
    customUrl = json['customUrl'];
    path = json['path'];
    repo = json['repo'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch'] = this.branch;
    data['customUrl'] = this.customUrl;
    data['path'] = this.path;
    data['repo'] = this.repo;
    data['token'] = this.token;
    return data;
  }
}
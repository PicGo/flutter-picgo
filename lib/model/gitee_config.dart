class GiteeConfig {
  String owner;
  String repo;
  String branch;
  String token;
  String storagePath;
  String customDomain;

  GiteeConfig(
      {this.owner,
      this.repo,
      this.branch,
      this.token,
      this.storagePath,
      this.customDomain});

  GiteeConfig.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    repo = json['repo'];
    branch = json['branch'];
    token = json['token'];
    storagePath = json['storagePath'];
    customDomain = json['customDomain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['repo'] = this.repo;
    data['branch'] = this.branch;
    data['token'] = this.token;
    data['storagePath'] = this.storagePath;
    data['customDomain'] = this.customDomain;
    return data;
  }
}
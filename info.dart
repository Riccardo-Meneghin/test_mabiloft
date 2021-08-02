class Info {
  final String title;
  final String url;

  const Info({
    required this.title,
    required this.url,
  });

  static Info fromJson(json) => Info(
        title: json['title'],
        url: json['url'],
      );
}

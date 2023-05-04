class RecentSearch {
  RecentSearch({required this.keyword});

  String keyword;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'keyword': keyword,
      };

  static RecentSearch fromJson(Map<String, dynamic> json) => RecentSearch(
        keyword: json['keyword'] as String,
      );
}

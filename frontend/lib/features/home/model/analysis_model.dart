class AnalysisModel {
  final int spam_count;
  final int positive_spam;
  final int neutral_spam;
  final int negative_spam;
  final int positive_not_spam;
  final int neutral_not_spam;
  final int negative_not_spam;
  final String product_name;

  const AnalysisModel({
    required this.spam_count,
    required this.positive_spam,
    required this.neutral_spam,
    required this.negative_spam,
    required this.positive_not_spam,
    required this.neutral_not_spam,
    required this.negative_not_spam,
    required this.product_name,
  });

  AnalysisModel copyWith({
    int? spam_count,
    int? positive_spam,
    int? neutral_spam,
    int? negative_spam,
    int? positive_not_spam,
    int? neutral_not_spam,
    int? negative_not_spam,
    String? product_name,
  }) {
    return AnalysisModel(
      spam_count: spam_count ?? this.spam_count,
      positive_spam: positive_spam ?? this.positive_spam,
      neutral_spam: neutral_spam ?? this.neutral_spam,
      negative_spam: negative_spam ?? this.negative_spam,
      positive_not_spam: positive_not_spam ?? this.positive_not_spam,
      neutral_not_spam: neutral_not_spam ?? this.neutral_not_spam,
      negative_not_spam: negative_not_spam ?? this.negative_not_spam,
      product_name: product_name ?? this.product_name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spam_count': spam_count,
      'positive_spam': positive_spam,
      'neutral_spam': neutral_spam,
      'negative_spam': negative_spam,
      'positive_not_spam': positive_not_spam,
      'neutral_not_spam': neutral_not_spam,
      'negative_not_spam': negative_not_spam,
      'product_name': product_name,
    };
  }

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      spam_count: json['spam_count'] as int,
      positive_spam: json['positive_spam'] as int,
      neutral_spam: json['neutral_spam'] as int,
      negative_spam: json['negative_spam'] as int,
      positive_not_spam: json['positive_not_spam'] as int,
      neutral_not_spam: json['neutral_not_spam'] as int,
      negative_not_spam: json['negative_not_spam'] as int,
      product_name: json['product_name'] as String,
    );
  }
}

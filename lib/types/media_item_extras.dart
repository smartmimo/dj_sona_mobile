class MediaItemExtras {
  final String streamUrl;
  final String? publishedTimeString;
  final String? viewsString;
  final int? originalIndex;
  final int? shuffledIndex;

  MediaItemExtras({
    required this.streamUrl,
    this.publishedTimeString,
    this.viewsString,
    this.originalIndex,
    this.shuffledIndex,
  });

  factory MediaItemExtras.fromJson(Map<String, dynamic> json) {
    return MediaItemExtras(
      streamUrl: json['streamUrl'],
      publishedTimeString: json['publishedTimeString'],
      viewsString: json['viewsString'],
      originalIndex: json['originalIndex'],
      shuffledIndex: json['shuffledIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "streamUrl": streamUrl,
      "publishedTimeString": publishedTimeString,
      "viewsString": viewsString,
      "originalIndex": originalIndex,
      "shuffledIndex": shuffledIndex,
    };
  }

  MediaItemExtras copyWith({
    String? streamUrl,
    String? publishedTimeString,
    String? viewsString,
    int? originalIndex,
    int? shuffledIndex,
  }) {
    return MediaItemExtras(
      streamUrl: streamUrl ?? this.streamUrl,
      publishedTimeString: publishedTimeString ?? this.publishedTimeString,
      viewsString: viewsString ?? this.viewsString,
      originalIndex: originalIndex ?? this.originalIndex,
      shuffledIndex: shuffledIndex ?? this.shuffledIndex,
    );
  }
}

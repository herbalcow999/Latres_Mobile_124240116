String showImageUrl(Map<String, dynamic> show) {
  final image = show['image'];
  if (image is Map) {
    return (image['medium'] ?? image['original'] ?? '').toString();
  }
  return '';
}

String showRating(Map<String, dynamic> show) {
  final rating = show['rating'];
  if (rating is Map && rating['average'] != null) {
    return (rating['average'] as num).toStringAsFixed(1);
  }
  return 'N/A';
}

List<String> showGenres(Map<String, dynamic> show) {
  final genres = show['genres'];
  if (genres is List) {
    return genres.map((genre) => genre.toString()).toList();
  }
  return <String>[];
}

String cleanSummary(dynamic value) {
  if (value == null) return 'Belum ada ringkasan untuk tayangan ini.';
  var text = value.toString();
  text = text.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ');
  text = text.replaceAll(RegExp(r'</p\s*>', caseSensitive: false), ' ');
  text = text.replaceAll(RegExp(r'<[^>]*>'), ' ');
  text = text
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');
  text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  return text.isEmpty ? 'Belum ada ringkasan untuk tayangan ini.' : text;
}

Map<String, dynamic> favoritePayload(Map<String, dynamic> show) {
  return <String, dynamic>{
    'id': show['id'],
    'name': show['name'] ?? 'Tanpa judul',
    'image': show['image'],
    'rating': show['rating'],
    'genres': show['genres'] ?? <dynamic>[],
    'summary': show['summary'] ?? '',
    'language': show['language'] ?? '',
    'status': show['status'] ?? '',
    'premiered': show['premiered'] ?? '',
  };
}

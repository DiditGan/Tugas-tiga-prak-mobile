class AnimeDetail {
  final String name;
  final String image;
  final Map<String, dynamic> family;
  final Map<String, dynamic> debut;
  final String? kekkeiGenkai;

  AnimeDetail({
    required this.name,
    required this.image,
    required this.family,
    required this.debut,
    this.kekkeiGenkai,
  });

  static const String _fallbackImage = "https://placeholder.co/400";

  factory AnimeDetail.fromJson(Map<String, dynamic> json) {
    // Ambil list gambar
    final List<dynamic>? images = json['images'];

    // Tentukan gambar yang akan digunakan
    String selectedImage = _fallbackImage;
    if (images != null && images.isNotEmpty) {
      final firstImage = images[0];
      if (firstImage is String && firstImage.trim().isNotEmpty) {
        selectedImage = firstImage;
      }
    }

    // Ambil data kekkei genkai
    String? kekkeiGenkai;
    final rawKekkei = json['personal']?['kekkeiGenkai'];
    if (rawKekkei is List) {
      kekkeiGenkai = rawKekkei.join(', ');
    } else if (rawKekkei is String && rawKekkei.trim().isNotEmpty) {
      kekkeiGenkai = rawKekkei;
    }

    return AnimeDetail(
      name: (json['name'] ?? "Unknown").toString(),
      image: selectedImage,
      family: Map<String, dynamic>.from(json['family'] ?? {}),
      debut: Map<String, dynamic>.from(json['debut'] ?? {}),
      kekkeiGenkai: kekkeiGenkai,
    );
  }
}
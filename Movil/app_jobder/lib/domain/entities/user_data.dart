class UserData {
  final String name;
  final String imageUrl;
  final int age;
  final String? bio;
  final List<String>? sharedInterests;

  UserData({
    required this.name,
    required this.imageUrl,
    required this.age,
    this.bio,
    this.sharedInterests,
  });
}

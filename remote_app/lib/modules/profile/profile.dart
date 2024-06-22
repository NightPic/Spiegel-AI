class Profile {
  String id;
  String name;
  bool isSelected;
  List<int>? selectedWidgetIds;
  List<Map<String, dynamic>>? selectedRemoteContent;

  Profile({
    required this.id,
    required this.name,
    this.isSelected = false,
    this.selectedWidgetIds,
    this.selectedRemoteContent,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      isSelected: json['isSelected'] ?? false,
      selectedWidgetIds: (json['selectedWidgetIds'] as List<dynamic>?)
          ?.map((id) => id as int)
          .toList(),
      selectedRemoteContent: (json['selectedRemoteContent'] as List<dynamic>?)
          ?.map((item) => item as Map<String, dynamic>)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isSelected': isSelected,
      'selectedWidgetIds': selectedWidgetIds,
      'selectedRemoteContent': selectedRemoteContent,
    };
  }

  void select() {
    isSelected = true;
  }

  void deselect() {
    isSelected = false;
  }
}

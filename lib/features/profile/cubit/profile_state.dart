class ProfileState {
  final String username;
  final String lastUpdated;
  final int relationshipsCount;
  final int uploadedChatsCount;
  final int totalMessagesCount;

  const ProfileState({
    this.username = 'ayushaswal',
    this.lastUpdated = 'August 19, 2026',
    this.relationshipsCount = 1,
    this.uploadedChatsCount = 0,
    this.totalMessagesCount = 7,
  });

  ProfileState copyWith({
    String? username,
    String? lastUpdated,
    int? relationshipsCount,
    int? uploadedChatsCount,
    int? totalMessagesCount,
  }) {
    return ProfileState(
      username: username ?? this.username,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      relationshipsCount: relationshipsCount ?? this.relationshipsCount,
      uploadedChatsCount: uploadedChatsCount ?? this.uploadedChatsCount,
      totalMessagesCount: totalMessagesCount ?? this.totalMessagesCount,
    );
  }
}

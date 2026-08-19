class HomeState {
  final String username;
  final int selectedNavIndex;

  const HomeState({this.username = 'ayushaswal', this.selectedNavIndex = 0});

  HomeState copyWith({String? username, int? selectedNavIndex}) {
    return HomeState(
      username: username ?? this.username,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
    );
  }
}

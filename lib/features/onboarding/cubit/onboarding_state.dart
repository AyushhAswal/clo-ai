class OnboardingState {
  final int currentPage;
  final int totalPages;
  final bool isCompleted;

  const OnboardingState({
    required this.currentPage,
    this.totalPages = 4,
    this.isCompleted = false,
  });

  bool get isFirstPage => currentPage == 0;
  bool get isLastPage => currentPage == totalPages - 1;

  OnboardingState copyWith({
    int? currentPage,
    int? totalPages,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

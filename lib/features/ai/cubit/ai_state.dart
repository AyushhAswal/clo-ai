class AIState {
  final String relationshipName;
  final String category;
  final int activeControlIndex;

  const AIState({
    this.relationshipName = 'Ayush',
    this.category = 'Professional',
    this.activeControlIndex =
        1, // 0 = Chat, 1 = Text/Input, 2 = Mic, 3 = Action
  });

  AIState copyWith({
    String? relationshipName,
    String? category,
    int? activeControlIndex,
  }) {
    return AIState(
      relationshipName: relationshipName ?? this.relationshipName,
      category: category ?? this.category,
      activeControlIndex: activeControlIndex ?? this.activeControlIndex,
    );
  }
}

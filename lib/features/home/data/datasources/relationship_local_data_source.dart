import '../../domain/models/relationship_model.dart';
import '../../../relationship/domain/models/question_model.dart';

abstract class RelationshipLocalDataSource {
  List<RelationshipModel> getRelationships();
  void addRelationship(RelationshipModel relationship);
  List<QuestionModel> getQuestionsForType(
    String relationshipType,
    String personName,
  );
}

class RelationshipLocalDataSourceImpl implements RelationshipLocalDataSource {
  static final RelationshipLocalDataSourceImpl _instance =
      RelationshipLocalDataSourceImpl._internal();

  factory RelationshipLocalDataSourceImpl() => _instance;

  RelationshipLocalDataSourceImpl._internal();

  final List<RelationshipModel> _relationships = [
    const RelationshipModel(
      id: '1',
      name: 'Ayush',
      relationshipType: 'Professional',
      category: 'Professional',
    ),
    const RelationshipModel(
      id: '2',
      name: 'Rahul',
      relationshipType: 'Friendship',
      category: 'Friends',
    ),
    const RelationshipModel(
      id: '3',
      name: 'Neha',
      relationshipType: 'Family',
      category: 'Family',
    ),
    const RelationshipModel(
      id: '4',
      name: 'Someone',
      relationshipType: 'Romantic',
      category: 'Romantic',
    ),
  ];

  @override
  List<RelationshipModel> getRelationships() {
    return List.unmodifiable(_relationships);
  }

  @override
  void addRelationship(RelationshipModel relationship) {
    _relationships.add(relationship);
  }

  @override
  List<QuestionModel> getQuestionsForType(
    String relationshipType,
    String personName,
  ) {
    final String typeLower = relationshipType.toLowerCase();

    if (typeLower.contains('friend')) {
      return [
        QuestionModel(
          id: 'q1',
          questionText: "Where's your friendship with $personName at?",
          options: [
            "New — still getting closer.",
            "Close, and it feels solid.",
            "Changed — we care, but the rhythm's off.",
            "Uneven — I give more, or something's unsaid.",
          ],
          relationshipType: relationshipType,
        ),
        QuestionModel(
          id: 'q2',
          questionText: "What comes up most strongly around $personName?",
          options: [
            "Ease — I can be myself.",
            "Loyalty — I care a lot.",
            "Let down — I expected more.",
            "Unsure — where I stand, or missing what was.",
          ],
          relationshipType: relationshipType,
        ),
        QuestionModel(
          id: 'q3',
          questionText: "What do you most want from $personName?",
          options: [
            "More effort — to feel chosen.",
            "More honesty — no more pretending.",
            "What we used to have, back.",
            "Space, or a reset.",
          ],
          relationshipType: relationshipType,
        ),
      ];
    } else if (typeLower.contains('romantic')) {
      return [
        QuestionModel(
          id: 'q1',
          questionText:
              "Where is your relationship with $personName currently?",
          options: [
            "Flourishing — deeply connected and aligned.",
            "Stable — comfortable, but missing spark.",
            "Tense — frequent friction and misunderstandings.",
            "Uncertain — questioning long-term harmony.",
          ],
          relationshipType: relationshipType,
        ),
        QuestionModel(
          id: 'q2',
          questionText: "What emotion is most prominent with $personName?",
          options: [
            "Warmth & Security",
            "Passion & Drive",
            "Anxiety or Guardedness",
            "Longing for deeper intimacy",
          ],
          relationshipType: relationshipType,
        ),
        QuestionModel(
          id: 'q3',
          questionText: "What is your main desire for $personName?",
          options: [
            "Deeper emotional openness",
            "Better conflict resolution",
            "More quality shared time",
            "Clarity on shared future goals",
          ],
          relationshipType: relationshipType,
        ),
      ];
    } else if (typeLower.contains('professional')) {
      return [
        QuestionModel(
          id: 'q1',
          questionText:
              "How would you describe your working dynamic with $personName?",
          options: [
            "Highly collaborative & effective",
            "Professional but distant",
            "Frictional — communication barriers exist",
            "Hierarchical tension or misalignment",
          ],
          relationshipType: relationshipType,
        ),
        QuestionModel(
          id: 'q2',
          questionText: "What key feeling arises during work with $personName?",
          options: [
            "Productive synergy & trust",
            "Cautious respect",
            "Frustration or micromanagement feeling",
            "Unclear expectations",
          ],
          relationshipType: relationshipType,
        ),
        QuestionModel(
          id: 'q3',
          questionText: "What outcome do you want with $personName?",
          options: [
            "Smoother daily communication",
            "Clearer boundaries & roles",
            "Greater recognition & mutual respect",
            "Professional resolution of past friction",
          ],
          relationshipType: relationshipType,
        ),
      ];
    } else {
      // Family
      return [
        QuestionModel(
          id: 'q1',
          questionText:
              "How does your connection with family member $personName feel?",
          options: [
            "Close and supportive",
            "Traditional — bonded by duty",
            "Complicated — unresolved past issues",
            "Distant — rarely communicating deeply",
          ],
          relationshipType: relationshipType,
        ),
        QuestionModel(
          id: 'q2',
          questionText: "What describes family interactions with $personName?",
          options: [
            "Comfortable warmth",
            "Cautious topics to avoid conflict",
            "Emotional weight or expectation",
            "Genuinely joy-filled",
          ],
          relationshipType: relationshipType,
        ),
        QuestionModel(
          id: 'q3',
          questionText: "What do you hope for in your bond with $personName?",
          options: [
            "Heal old misunderstandings",
            "Establish healthier personal boundaries",
            "More frequent meaningful check-ins",
            "Maintain current peaceful balance",
          ],
          relationshipType: relationshipType,
        ),
      ];
    }
  }
}

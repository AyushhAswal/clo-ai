import 'package:clo_ai/core/constants/app_colors.dart';
import 'package:clo_ai/core/constants/app_spacing.dart';
import 'package:clo_ai/features/ai/presentation/screens/ai_vent_screen.dart';
import 'package:clo_ai/features/home/data/repositories/relationship_repository.dart';
import 'package:clo_ai/features/home/domain/models/relationship_model.dart';
import 'package:clo_ai/features/home/presentation/widgets/relationship_card.dart';
import 'package:clo_ai/features/relationship/presentation/screens/add_relationship_name_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCircleScreen extends StatefulWidget {
  const MyCircleScreen({super.key});

  @override
  State<MyCircleScreen> createState() => _MyCircleScreenState();
}

class _MyCircleScreenState extends State<MyCircleScreen> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = const [
    {'label': 'All', 'icon': null},
    {'label': 'Romantic', 'icon': Icons.favorite_border_rounded},
    {'label': 'Professional', 'icon': Icons.work_outline_rounded},
    {'label': 'Friends', 'icon': Icons.people_outline_rounded},
    {'label': 'Family', 'icon': Icons.language_rounded},
  ];

  void _onPersonTap(RelationshipModel person) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AIVentScreen(
          personName: person.name,
          relationshipType: person.relationshipType,
        ),
      ),
    );
  }

  void _onAddPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddRelationshipNameScreen(),
      ),
    );
    // Refresh list when returning from Add Relationship Questionnaire
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final allRelationships = LocalRelationshipRepository().getRelationships();

    final filteredRelationships = _selectedCategory == 'All'
        ? allRelationships
        : allRelationships.where((item) {
            if (_selectedCategory == 'Friends') {
              return item.category == 'Friends' ||
                  item.relationshipType.toLowerCase().contains('friend');
            }
            return item.category.toLowerCase() ==
                _selectedCategory.toLowerCase();
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: Container(
          width: 58.r,
          height: 58.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFC451A4), Color(0xFFBA42A2)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFBA42A2).withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _onAddPressed,
              child: Icon(Icons.add_rounded, color: Colors.white, size: 32.r),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: AppSpacing.sm.h, bottom: 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Title & Search Icon Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Circle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF161622),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 22.r,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Horizontal Category Selector Filter Tabs
              SizedBox(
                height: 38.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final String label = category['label'] as String;
                    final IconData? icon = category['icon'] as IconData?;
                    final bool isSelected = _selectedCategory == label;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = label;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: EdgeInsets.only(right: 10.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE5E5EA)
                              : const Color(0xFF161622),
                          borderRadius: BorderRadius.circular(20.r),
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1,
                                ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null) ...[
                              Icon(
                                icon,
                                size: 15.r,
                                color: isSelected
                                    ? Colors.black
                                    : AppColors.textSecondary,
                              ),
                              SizedBox(width: 6.w),
                            ],
                            Text(
                              label,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : AppColors.textSecondary,
                                fontSize: 13.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),

              // Connection Cards Grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Wrap(
                  spacing: 16.w,
                  runSpacing: 16.h,
                  children: [
                    AddRelationshipItem(onTap: _onAddPressed),
                    ...filteredRelationships.map(
                      (person) => ExistingRelationshipItem(
                        name: person.name,
                        category: person.relationshipType,
                        onTap: () => _onPersonTap(person),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

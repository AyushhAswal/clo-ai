import 'package:clo_ai/core/constants/app_colors.dart';
import 'package:clo_ai/core/constants/app_spacing.dart';
import 'package:clo_ai/features/ai/presentation/screens/ai_loading_screen.dart';
import 'package:clo_ai/features/ai/presentation/screens/ai_vent_screen.dart';
import 'package:clo_ai/features/home/cubit/my_circle_cubit.dart';
import 'package:clo_ai/features/home/cubit/my_circle_state.dart';
import 'package:clo_ai/features/home/data/repositories/relationship_repository.dart';
import 'package:clo_ai/features/home/domain/models/relationship_model.dart';
import 'package:clo_ai/features/home/presentation/widgets/relationship_card.dart';
import 'package:clo_ai/features/relationship/presentation/screens/add_relationship_name_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCircleScreen extends StatelessWidget {
  final RelationshipRepository? repository;
  final MyCircleCubit? cubit;

  const MyCircleScreen({super.key, this.repository, this.cubit});

  @override
  Widget build(BuildContext context) {
    if (cubit != null) {
      return BlocProvider.value(
        value: cubit!,
        child: const _MyCircleScreenView(),
      );
    }

    final parentCubit = context.watch<MyCircleCubit?>();
    if (parentCubit != null) {
      return BlocProvider.value(
        value: parentCubit,
        child: const _MyCircleScreenView(),
      );
    }

    return BlocProvider(
      create: (context) =>
          MyCircleCubit(repository: repository)..loadRelationships(),
      child: const _MyCircleScreenView(),
    );
  }
}

class _MyCircleScreenView extends StatefulWidget {
  const _MyCircleScreenView();

  @override
  State<_MyCircleScreenView> createState() => _MyCircleScreenViewState();
}

class _MyCircleScreenViewState extends State<_MyCircleScreenView> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = const [
    {'label': 'All', 'icon': null},
    {'label': 'Romantic', 'icon': Icons.favorite_border_rounded},
    {'label': 'Professional', 'icon': Icons.work_outline_rounded},
    {'label': 'Friends', 'icon': Icons.people_outline_rounded},
    {'label': 'Family', 'icon': Icons.language_rounded},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onPersonTap(RelationshipModel person) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AILoadingScreen(
          targetScreen: AIVentScreen(
            relationshipId: person.id,
            personName: person.name,
            relationshipType: person.category,
          ),
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
    if (mounted) {
      context.read<MyCircleCubit>().loadRelationships();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: BlocBuilder<MyCircleCubit, MyCircleState>(
          builder: (context, state) {
            final filteredRelationships = state.filteredRelationships;
            final isSearching = state.isSearching;

            return SingleChildScrollView(
              padding: EdgeInsets.only(top: AppSpacing.sm.h, bottom: 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Title & Search Bar / Icon
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: isSearching
                        ? Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 42.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF161622),
                                    borderRadius: BorderRadius.circular(21.r),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    autofocus: true,
                                    onChanged: (query) {
                                      context
                                          .read<MyCircleCubit>()
                                          .setSearchQuery(query);
                                    },
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                    cursorColor: AppColors.primaryAccent,
                                    decoration: InputDecoration(
                                      hintText: 'Search by name...',
                                      hintStyle: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13.sp,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: AppColors.textSecondary,
                                        size: 20.r,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  context.read<MyCircleCubit>().toggleSearch();
                                },
                                child: Container(
                                  width: 40.r,
                                  height: 40.r,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF161622),
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 20.r,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
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
                              GestureDetector(
                                onTap: () {
                                  context.read<MyCircleCubit>().toggleSearch();
                                },
                                child: Container(
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
                        final bool isSelected = state.selectedCategory == label;

                        return GestureDetector(
                          onTap: () {
                            context.read<MyCircleCubit>().selectCategory(label);
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
                                      color: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
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

                  // Content Body State Handling
                  if (state.status == MyCircleStatus.loading) ...[
                    SizedBox(height: 60.h),
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ] else if (state.status == MyCircleStatus.error) ...[
                    SizedBox(height: 40.h),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_off_rounded,
                              color: Colors.white60,
                              size: 44.r,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              state.errorMessage ?? 'Failed to load My Circle',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<MyCircleCubit>()
                                    .loadRelationships();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

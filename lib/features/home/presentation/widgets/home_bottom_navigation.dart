import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class _TabItemData {
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final String label;

  const _TabItemData({
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.label,
  });
}

class HomeBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  // Strict 3-Tab Navigation System: 0 = Home, 1 = AI, 2 = Profile
  static const List<_TabItemData> _tabs = [
    _TabItemData(
      unselectedIcon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _TabItemData(
      unselectedIcon: Icons.explore_outlined,
      selectedIcon: Icons.explore_rounded,
      label: 'AI',
    ),
    _TabItemData(
      unselectedIcon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  const HomeBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp selectedIndex strictly to 3 valid tabs: [0, 1, 2]
    final int activeIndex = selectedIndex.clamp(0, _tabs.length - 1);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(left: 40.w, right: 40.w, bottom: 12.h),
        child: Center(
          child: Container(
            height: 52.h,
            constraints: BoxConstraints(maxWidth: 320.w),
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: AppColors.bottomNavBg,
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.40),
                  blurRadius: 18.r,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Sliding White Active Pill Background (Slides ONLY between Home ↔ AI ↔ Profile)
                AnimatedAlign(
                  alignment: Alignment(-1.0 + (activeIndex * 1.0), 0.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  child: FractionallySizedBox(
                    widthFactor: 1 / 3,
                    heightFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.bottomNavActiveBg,
                        borderRadius: BorderRadius.circular(22.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Row of 3 Equal Interactive Navigation Tabs
                Row(
                  children: List.generate(_tabs.length, (index) {
                    final tab = _tabs[index];
                    final bool isSelected = activeIndex == index;

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onTabSelected(index),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.bottomNavActiveText
                                  : Colors.white.withValues(alpha: 0.70),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TweenAnimationBuilder<Color?>(
                                  tween: ColorTween(
                                    begin: Colors.white.withValues(alpha: 0.70),
                                    end: isSelected
                                        ? AppColors.bottomNavActiveText
                                        : Colors.white.withValues(alpha: 0.70),
                                  ),
                                  duration: const Duration(milliseconds: 250),
                                  builder: (context, color, child) {
                                    return Icon(
                                      isSelected
                                          ? tab.selectedIcon
                                          : tab.unselectedIcon,
                                      color: color,
                                      size: 19.r,
                                    );
                                  },
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOutCubic,
                                  child: isSelected
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 6.w),
                                          child: Text(
                                            tab.label,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

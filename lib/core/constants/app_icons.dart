import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Centralized Icon System using Phosphor Icons for a clean, consistent visual language across CLO AI.
abstract class AppIcons {
  // Navigation Icons (Used in HomeBottomNavigation)
  static const IconData home = PhosphorIconsRegular.house;
  static const IconData homeActive = PhosphorIconsFill.house;

  static const IconData myCircle = PhosphorIconsRegular.usersThree;
  static const IconData myCircleActive = PhosphorIconsRegular.usersThree;

  static const IconData profile = PhosphorIconsRegular.user;
  static const IconData profileActive = PhosphorIconsFill.user;

  // General Application Icons
  static const IconData search = PhosphorIconsRegular.magnifyingGlass;
  static const IconData add = PhosphorIconsRegular.plus;
  static const IconData back = PhosphorIconsRegular.caretLeft;
  static const IconData forward = PhosphorIconsRegular.caretRight;
  static const IconData close = PhosphorIconsRegular.x;
  static const IconData check = PhosphorIconsRegular.check;
  static const IconData delete = PhosphorIconsRegular.trash;
  static const IconData edit = PhosphorIconsRegular.pencilSimple;
  static const IconData settings = PhosphorIconsRegular.gear;
  static const IconData notification = PhosphorIconsRegular.bell;
  static const IconData send = PhosphorIconsRegular.paperPlaneRight;
  static const IconData camera = PhosphorIconsRegular.camera;
  static const IconData image = PhosphorIconsRegular.image;
  static const IconData heart = PhosphorIconsRegular.heart;
  static const IconData heartActive = PhosphorIconsFill.heart;
  static const IconData more = PhosphorIconsRegular.dotsThree;
  static const IconData arrowDown = PhosphorIconsRegular.caretDown;
  static const IconData arrowUp = PhosphorIconsRegular.caretUp;
}

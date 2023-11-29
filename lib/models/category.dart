import 'package:flutter/material.dart';

enum CategoryList {
  general, // כללי
  study, // לימודים
  leisure, // בילויים
  buisness, // עסקים
  work, // עבודה
}

const categoryIcons = {
  CategoryList.general: Icons.article_outlined,
  CategoryList.study: Icons.school_outlined,
  CategoryList.work: Icons.work_history_outlined,
  CategoryList.leisure: Icons.fmd_good_outlined,
  CategoryList.buisness: Icons.attach_money,
};


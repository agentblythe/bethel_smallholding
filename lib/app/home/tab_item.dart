import 'package:flutter/material.dart';

enum TabItem {
  blog,
  account,
}

class TabItemData {
  const TabItemData({required this.label, required this.icon});

  final String label;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.blog: TabItemData(
      label: "Blog",
      icon: Icons.book,
    ),
    TabItem.account: TabItemData(
      label: "Account",
      icon: Icons.person,
    )
  };
}

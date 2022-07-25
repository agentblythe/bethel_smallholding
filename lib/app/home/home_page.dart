import 'package:bethel_smallholding/app/home/account/account_page.dart';
import 'package:bethel_smallholding/app/home/blog/blog_page.dart';
import 'package:bethel_smallholding/app/home/cupertino_home_scaffold.dart';
import 'package:bethel_smallholding/app/home/tab_item.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTabItem = TabItem.blog;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.blog: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.blog: (_) => const BlogPage(),
      TabItem.account: (_) => const AccountPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: CupertinoHomeScaffold(
        currentTab: _currentTabItem,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
      onWillPop: _willPop,
    );
  }

  Future<bool> _willPop() async {
    return !(await navigatorKeys[_currentTabItem]!.currentState!.maybePop());
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTabItem) {
      // Pop to first route
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    }
    setState(() {
      _currentTabItem = tabItem;
    });
  }
}

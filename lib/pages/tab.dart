// ignore_for_file: constant_identifier_names, body_might_complete_normally_nullable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:klyc/components/appbar_text.dart';
import 'package:klyc/pages/admin_page.dart';
import 'package:klyc/pages/custom_drawer.dart';
import 'package:klyc/pages/my_favorite_page.dart';
import 'package:klyc/pages/pages.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _MyTabViews.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      extendBody: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const AppBarText(),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.person_2_rounded,
              size: 28,
            ),
          ),
        ],
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [
          FirstPage(),
          FavoritePage(),
          AdminPage(),
        ],
      ),
      drawer: const SafeArea(
        child: CustomDrawer(),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.black,
        notchMargin: 10,
        child: TabBar(
          indicatorColor: Colors.white,
          padding: EdgeInsets.zero,
          controller: _tabController,
          tabs: _MyTabViews.values
              .map((e) => Tab(icon: Icon(tabIcons[e])))
              .toList(),
        ),
      ),
    );
  }
}

enum _MyTabViews { HOME, FAVORITE, ADMIN }

extension _MyTabViewExtension on _MyTabViews {}

final tabIcons = {
  _MyTabViews.HOME: Icons.home,
  _MyTabViews.ADMIN: Icons.newspaper_outlined,
  _MyTabViews.FAVORITE: Icons.favorite,
};



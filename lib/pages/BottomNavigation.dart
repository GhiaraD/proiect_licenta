import 'package:SoundTrek/pages/AchievementsView.dart';
import 'package:SoundTrek/pages/LeaderboardView.dart';
import 'package:SoundTrek/pages/ProfileView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/colors.dart' as my_colors;
import 'MapPage.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key, this.tabIndex = 0});

  final int tabIndex;

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> with TickerProviderStateMixin {
  late List<Widget> tabs;
  late TabController tabController;
  final PageStorageBucket bucket = PageStorageBucket();
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.blue, // Set the color you want here
      systemNavigationBarIconBrightness: Brightness.light, // Set icon brightness
    ));
    tabController = TabController(vsync: this, length: 4);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          currentTab = tabController.index;
        });
      }
    });
    tabs = [
      const MapPage(),
      const AchievementView(),
      const LeaderboardView(),
      ProfilePage(),
    ];
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: widget.tabIndex,
      child: Scaffold(
        backgroundColor: my_colors.Colors.greyBackground,
        body: PageStorage(
          bucket: bucket,
          child: TabBarView(controller: tabController, children: tabs),
        ),
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 52,
            child: Column(
              children: [
                const Divider(indent: 0, endIndent: 0, height: 1),
                Expanded(
                  child: TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(
                        icon: currentTab == 0
                            ? const Icon(Icons.map, color: my_colors.Colors.primary)
                            : const Icon(Icons.map_outlined, color: Colors.black54),
                        iconMargin: EdgeInsets.zero,
                      ),
                      Tab(
                        icon: currentTab == 1
                            ? Image.asset("lib/assets/images/medal_primary.png", height: 24, width: 24)
                            : Image.asset("lib/assets/images/medal_black.png", height: 24, width: 24),
                        iconMargin: EdgeInsets.zero,
                      ),
                      Tab(
                        icon: currentTab == 2
                            ? Image.asset("lib/assets/images/leaderboard_primary.png", height: 24, width: 24)
                            : Image.asset("lib/assets/images/leaderboard_black.png", height: 24, width: 24),
                        iconMargin: EdgeInsets.zero,
                      ),
                      Tab(
                        icon: currentTab == 3
                            ? const Icon(Icons.person, color: my_colors.Colors.primary)
                            : const Icon(Icons.person_outlined, color: Colors.black54),
                        iconMargin: EdgeInsets.zero,
                      ),
                    ],
                    labelColor: Theme.of(context).colorScheme.primary,
                    labelPadding: const EdgeInsets.only(top: 4),
                    unselectedLabelColor: Theme.of(context).unselectedWidgetColor,
                    indicatorColor: Colors.transparent,
                    overlayColor: const MaterialStatePropertyAll<Color>(my_colors.Colors.primaryOverlay),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

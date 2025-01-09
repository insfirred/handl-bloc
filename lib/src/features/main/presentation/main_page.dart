import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handl_bloc/src/features/profile/presentation/profile_page.dart';

import '../../../routing/app_router.dart';
import '../../auth/presentation/auth_cubit.dart';
import '../../auth/presentation/auth_state.dart';
import '../../home/presentation/home_page.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: _bottomNavIndex == 0
                ? const HomePage()
                : ProfilePage(auth.currentUser!.uid),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.navigateTo(const AddPostRoute());
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              return Icon(
                iconList[index],
                size: 24,
                color: isActive ? Theme.of(context).primaryColor : Colors.grey,
              );
            },
            splashColor: Theme.of(context).primaryColor,
            activeIndex: _bottomNavIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) => setState(() => _bottomNavIndex = index),
            //other params
          ),
        );
      },
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.replaceRoute(const AuthRoute());
        }
      },
    );
  }
}

List iconList = [
  Icons.home,
  Icons.person,
];

int _bottomNavIndex = 0;

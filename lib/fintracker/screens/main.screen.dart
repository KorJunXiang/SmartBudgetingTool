import 'package:SmartBudget/chat/pages/pages.dart';
import 'package:SmartBudget/chat/providers/auth_provider.dart';
import 'package:SmartBudget/fintracker/bloc/cubit/app_cubit.dart';
import 'package:SmartBudget/fintracker/screens/accounts/accounts.screen.dart';
import 'package:SmartBudget/fintracker/screens/categories/categories.screen.dart';
import 'package:SmartBudget/fintracker/screens/home/home.screen.dart';
import 'package:SmartBudget/fintracker/screens/onboard/onboard_screen.dart';
import 'package:SmartBudget/fintracker/screens/settings/settings.screen.dart';
import 'package:SmartBudget/inventorymanagement/inventory/inventoryscreen.dart';
import 'package:SmartBudget/inventorymanagement/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _controller = PageController(keepPage: true);
  int _selected = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final authProvider = context.read<AuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  void _handleLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
      _selected = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = User(
        userID: "1",
        staffID: "B0001",
        userName: "JL8576",
        userPassword: "111111",
        userRole: "Employer",
        userStatus: "Active",
        userPhoneNumber: "0177076881",
        userEmail: "jialong999999@gmail.com",
        userRegistrationDate: "2024-04-20");

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        AppCubit cubit = context.read<AppCubit>();
        if (cubit.state.currency == null || cubit.state.username == null) {
          return OnboardScreen();
        }
        return Scaffold(
          body: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              AccountsScreen(),
              CategoriesScreen(),
              InventoryScreen(
                user: user,
              ),
              _isLoggedIn
                  ? HomePage()
                  : LoginPage(onLoginSuccess: _handleLoginSuccess),
              SettingsScreen()
            ],
            onPageChanged: (int index) {
              setState(() {
                _selected = index;
              });
            },
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selected,
            destinations: const [
              NavigationDestination(
                  icon: Icon(
                    Symbols.home,
                    fill: 1,
                  ),
                  label: "Home"),
              NavigationDestination(
                  icon: Icon(
                    Symbols.wallet,
                    fill: 1,
                  ),
                  label: "Accounts"),
              NavigationDestination(
                  icon: Icon(
                    Symbols.category,
                    fill: 1,
                  ),
                  label: "Categories"),
              NavigationDestination(
                  icon: Icon(
                    Symbols.inventory_2_rounded,
                    fill: 1,
                  ),
                  label: "Inventory"),
              NavigationDestination(
                  icon: Icon(
                    Symbols.chat_rounded,
                    fill: 1,
                  ),
                  label: "Chat"),
              NavigationDestination(
                  icon: Icon(
                    Symbols.settings,
                    fill: 1,
                  ),
                  label: "Settings"),
            ],
            onDestinationSelected: (int selected) {
              _controller.jumpToPage(selected);
            },
          ),
        );
      },
    );
  }
}

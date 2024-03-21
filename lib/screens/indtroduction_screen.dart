import 'package:app/l10n/app_localization.dart';
import 'package:app/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  IntroductionScreenState createState() => IntroductionScreenState();
}

class IntroductionScreenState extends State<IntroductionScreen> {
  final PageController _pageController = PageController();

  void _onPageChanged(int page) {
    setState(() {
    });
  }

  void _onProceed(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    List<Widget> introPages = [
      LogoPage(),
      IntroPage(
        title: appLocalizations.translate('shoppingPage'),
        description: appLocalizations.translate('shoppingPageDescription'),
        icon: Icons.shopping_cart,
      ),
      IntroPage(
        title: appLocalizations.translate('viewListPage'),
        description: appLocalizations.translate('viewListPageDescription'),
        icon: Icons.format_list_bulleted,
      ),
      IntroPage(
        title: appLocalizations.translate('addItemPage'),
        description: appLocalizations.translate('addItemPageDescription'),
        icon: Icons.add_box,
      ),
      IntroPage(
        title: appLocalizations.translate('myListsPage'),
        description: appLocalizations.translate('myListsPageDescription'),
        icon: Icons.format_list_bulleted_add,
      ),
      IntroPage(
        title: appLocalizations.translate('userPage'),
        description: appLocalizations.translate('userPageDescription'),
        icon: Icons.person,
        isLastPage: true,
        onProceed: () => _onProceed(context),
      ),
    ];

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: introPages,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: introPages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Theme.of(context).colorScheme.primary,
                dotColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                dotHeight: 10,
                dotWidth: 10,
                spacing: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo/shoppylist.png',
            width: 220,
            height: 220,
          ),
          const SizedBox(height: 24),
          Text(
            appLocalizations.translate('welcomeToShoppyList'),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            appLocalizations.translate('appDescription'),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class IntroPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isLastPage;
  final VoidCallback? onProceed;

  const IntroPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.isLastPage = false,
    this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          if (isLastPage) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onProceed,
              child: Text(AppLocalizations.of(context).translate('getStarted')),
            ),
          ],
        ],
      ),
    );
  }
}

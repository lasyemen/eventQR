import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/constants.dart'; // AppColors.primaryGradient, etc.
import 'package:qr_ksa/screens/my_events_screen.dart';
import 'package:qr_ksa/screens/plans_screen.dart';

class MyEventsScreen extends StatelessWidget {
  final List<Map<String, String>> events;
  const MyEventsScreen({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Gradient mainGradient = AppColors.primaryGradient;

    return Scaffold(
      appBar: AppBar(title: const Text('جميع فعالياتي')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (ctx, i) {
          final ev = events[i];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: mainGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  ev['title']!,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.right,
                ),
                subtitle: Text(
                  '${ev['date']} - ${ev['location']}',
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.right,
                ),
                trailing: ShaderMask(
                  shaderCallback: (bounds) => mainGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  blendMode: BlendMode.srcIn,
                  child: const FaIcon(FontAwesomeIcons.chevronLeft),
                ),
                onTap: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // default to Home
  final String userName = 'لؤي';
  late final ScrollController _scrollController;

  static const List<Map<String, String>> publicEvents = [
    {
      'title': 'مهرجان الرياض الثقافي',
      'date': '10 يوليو 2025',
      'location': 'الرياض',
      'imageUrl': 'assets/images/riyadh1.png',
    },
    {
      'title': 'معرض الكتاب',
      'date': '20 أغسطس 2025',
      'location': 'جدة',
      'imageUrl': 'assets/images/riyadh2.png',
    },
    {
      'title': 'مهرجان الموسيقى',
      'date': '5 سبتمبر 2025',
      'location': 'أبها',
      'imageUrl': 'assets/images/riyadh3.png',
    },
  ];

  static const List<Map<String, String>> myEvents = [
    {'title': 'ورشة عمل فلاتر', 'date': '12 يونيو 2025', 'location': 'الرياض'},
    {'title': 'لقاء الـ BLoC', 'date': '25 يوليو 2025', 'location': 'جدة'},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int idx) => setState(() => _selectedIndex = idx);

  Widget _buildScrollableContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'الفعاليات العامة',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 230,
            child: PageView.builder(
              controller: PageController(viewportFraction: 1.0),
              itemCount: publicEvents.length,
              itemBuilder: (_, idx) {
                final e = publicEvents[idx];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(e['imageUrl']!, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e['title']!,
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${e['date']} • ${e['location']}',
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'فعالياتي',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MyEventsScreen(events: myEvents),
                  ),
                ),
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myEvents.length,
            itemBuilder: (_, i) {
              final ev = myEvents[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      ev['title']!,
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Text(
                      '${ev['date']} - ${ev['location']}',
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    trailing: ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.primaryGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                      blendMode: BlendMode.srcIn,
                      child: const FaIcon(FontAwesomeIcons.chevronLeft),
                    ),
                    onTap: () {},
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCreateEventCard() {
    const double trigger = 270 + 24;
    final bool showShadow =
        _scrollController.hasClients && _scrollController.offset > trigger;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradient.colors[0].withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(-2, -2),
          ),
          BoxShadow(
            color: AppColors.primaryGradient.colors[3].withOpacity(0.9),
            blurRadius: 8,
            offset: const Offset(2, 2),
          ),
          if (showShadow)
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              spreadRadius: 4,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'إنشاء فعالية جديدة',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 6),
                Text(
                  'ابدأ بتنظيم فعاليتك وتواصل مع جمهورك',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PlansScreen(planType: null),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.add, size: 32, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainGradient = AppColors.primaryGradient;

    // helper to build a gradient-masked icon when selected
    Widget _gradientIcon(IconData iconData, bool selected) {
      return selected
          ? ShaderMask(
              shaderCallback: (bounds) => mainGradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              blendMode: BlendMode.srcIn,
              child: Icon(iconData, size: 30, color: Colors.white),
            )
          : Icon(iconData, size: 30, color: Colors.grey);
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _selectedIndex == 1
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: false,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => mainGradient.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      blendMode: BlendMode.srcIn,
                      child: FaIcon(
                        FontAwesomeIcons.qrcode,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ShaderMask(
                      shaderCallback: (bounds) => mainGradient.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                      blendMode: BlendMode.srcIn,
                      child: Text(
                        'مرحباً بك يا $userName',
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
        body: _selectedIndex == 1
            ? Column(
                children: [
                  Expanded(child: _buildScrollableContent()),
                  _buildCreateEventCard(),
                ],
              )
            : Center(
                child: Text(
                  _selectedIndex == 0 ? 'Settings Page' : 'Profile Page',
                  style: const TextStyle(fontSize: 24, color: Colors.black87),
                ),
              ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 1,
              decoration: BoxDecoration(gradient: mainGradient),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: _gradientIcon(
                      HugeIcons.strokeRoundedAccountSetting01,
                      _selectedIndex == 0,
                    ),
                    onPressed: () => _onItemTapped(0),
                  ),
                  GestureDetector(
                    onTap: () => _onItemTapped(1),
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 64),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: mainGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(
                          HugeIcons.strokeRoundedHome01,
                          size: 34,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _gradientIcon(
                      HugeIcons.strokeRoundedUser,
                      _selectedIndex == 2,
                    ),
                    onPressed: () => _onItemTapped(2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

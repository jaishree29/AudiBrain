import 'package:audibrain/utils/colors.dart';
import 'package:audibrain/utils/image_strings.dart';
import 'package:audibrain/views/home/app_drawer.dart';
import 'package:audibrain/views/notifications/notifications.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _isDrawerOpen = false;

  // List of supported languages
  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  String _selectedLanguage = 'English'; // Default language

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, -0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    if (_isDrawerOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  // Function to handle language change
  void _onLanguageChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedLanguage = newValue;
      });
      // Here you would typically call a function to update the app's language
      // For example: updateAppLanguage(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          splashColor: Colors.transparent,
          onTap: _toggleDrawer,
          child: const Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://img.freepik.com/free-vector/cute-cool-boy-dabbing-pose-cartoon-vector-icon-illustration-people-fashion-icon-concept-isolated_138676-5680.jpg?t=st=1733131305~exp=1733134905~hmac=a1b05ebdf1385da653bf6ec4e40b0bf395afbc7af28f13c8c9a70a47d7074292&w=740',
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontFamily: 'Canva Sans',
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'How are you today?',
                  style: const TextStyle(
                    fontFamily: 'Canva Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: AColors.primary,
                  ),
                ),
              ],
            ),
            InkWell(
              splashColor: AColors.primary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(50),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.notifications_active_rounded,
                    size: 25,
                    color: AColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  AImages.robot,
                  height: 250,
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                const Center(
                  child: Text(
                    'Welcome to AudiBrain',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Canva Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: AColors.primary,
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                Image.network(
                  'https://cdn.intuji.com/2023/10/Alterego-image-breakdown-1024x338.jpg',
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    'Let us know in which language you would like to communicate!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Canva Sans',
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // Drop down menu to select language
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    onChanged: _onLanguageChanged,
                    items: _languages
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    isExpanded: true,
                    hint: const Text('Select Language'),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _isDrawerOpen,
              child: SizedBox(
                height: screenHeight * 0.5,
                child: SlideTransition(
                  position: _animation,
                  child: const MyAppDrawer(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

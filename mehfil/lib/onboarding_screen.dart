import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mehfil/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  // Content data for each page
  final List<Map<String, dynamic>> onboardingData = [
    {
      "images": [
        'assets/onboarding/a-zuhri-m4PYeXVyzKY-unsplash.jpg',
        'assets/onboarding/ahmed-samy-vQblNa9bxw8-unsplash.jpg',
        'assets/onboarding/bhupesh-pal-t6B2an58aK0-unsplash.jpg',
        'assets/onboarding/darius-E-_I18oX5NQ-unsplash.jpg',
        'assets/onboarding/fabio-alves-DQq3MIMR7oU-unsplash.jpg',
        'assets/onboarding/georgie-cobbs-SU35VU5de1o-unsplash.jpg',
      ],
      "title1": "Find Your Favourite",
      "title2": "Events Here",
      "description": "explore the funniest and closest event to you",
    },
    {
      "images": [
        'assets/onboarding/jed-villejo-4SByp8kIoOE-unsplash.jpg',
        'assets/onboarding/john-arano-_qADvinJi20-unsplash.jpg',
        'assets/onboarding/jordon-conner-tIr-PWgSYB4-unsplash.jpg',
        'assets/onboarding/nik-0yTVA0TIq5o-unsplash.jpg',
        'assets/onboarding/raphael-renter-raphi_rawr-hlac8cLjoPo-unsplash.jpg',
        'assets/onboarding/roberto-rendon-oOkkB-wjUMo-unsplash.jpg',
      ],
      "title1": "Discover New Adventures",
      "title2": "Right Near You",
      "description": "Explore and book events that spark your interest.",
    },
  ];

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      setState(() {
        currentIndex++;
        _pageController.jumpToPage(currentIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentData = onboardingData[currentIndex];
    return Scaffold(
      backgroundColor: const Color(0xff26141C),
      body: Column(
        children: [
          // Staggered Grid View for Images
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, pageIndex) {
                final data = onboardingData[pageIndex];
                return MasonryGridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Three items per row
                  ),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: data["images"].length,
                  itemBuilder: (context, index) {
                    // Default size for containers
                    double containerHeight = 235;
                    double containerWidth = 180;

                    // Adjust the size for specific indices
                    if (index == 1) {
                      containerHeight =
                          175; // Make the middle container smaller
                      containerWidth =
                          180; // Optionally adjust the width as well
                    } else if (index == 3) {
                      containerHeight =
                          290; // Increase the height for container 5 (index 4)
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Container(
                        width: containerWidth,
                        height: containerHeight,
                        decoration: BoxDecoration(
                          color: Colors.grey[900], // Fallback color
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: Image.asset(
                          data["images"][index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Text Section
          Column(
            children: [
              Text(
                currentData["title1"],
                style: GoogleFonts.raleway(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                currentData["title2"],
                style: GoogleFonts.raleway(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                currentData["description"],
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  color: Colors.white38,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Page Indicator
          SmoothPageIndicator(
            controller: _pageController,
            count: onboardingData.length, // Total number of pages
            effect: const ExpandingDotsEffect(
              activeDotColor: Colors.pinkAccent,
              dotColor: Colors.grey,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 10, // Effect of expansion
              spacing: 8,
            ),
          ),
          const SizedBox(height: 20),
          // Button Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                if (currentIndex == onboardingData.length - 1) {
                  // Navigate to the next screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } else {
                  nextPage();
                }
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffF20587),Color(0xffF2059F), Color(0xffF207CB)])),
                child: Center(
                  child: Text(
                    currentIndex == onboardingData.length - 1
                        ? "Get started"
                        : "Next",
                    style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

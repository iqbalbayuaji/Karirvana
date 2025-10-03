import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:karirvana/app/modules/homepage/local_widget/carousel.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';
import 'package:karirvana/app/widgets/bottom_navbar.dart';
import '../../../routes/app_pages.dart';
import '../controllers/homepage_controller.dart';
import '../local_widget/Rekomendasi_Container.dart';
import '../local_widget/Rekomendasi_Container_certification.dart';
import '../local_widget/icon_features.dart';
import '../local_widget/course_progress_carousel.dart';

class HomepageView extends GetView<HomepageController> {
  const HomepageView({super.key});
  // Sample data for courses - in real app this would come from controller/API
  List<CourseData> _getSampleCourses() {
    return [
      CourseData(
        id: "1",
        title: "Express JS Intermediate",
        lastActivity: "Middleware",
        lastTime: "10:46",
        progress: 60.0,
      ),
      CourseData(
        id: "2", 
        title: "Flutter Advanced",
        lastActivity: "State Management",
        lastTime: "14:32",
        progress: 35.0,
      ),
      CourseData(
        id: "3",
        title: "React Native Basics", 
        lastActivity: "Components",
        lastTime: "09:15",
        progress: 80.0,
      ),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    print('🔍 DEBUG: HomepageView build() called');
    print('🔍 DEBUG: Controller instance: ${controller.runtimeType}');
    
    // Force controller initialization
    Get.find<HomepageController>();
    print('🔍 DEBUG: Controller found and accessed');
    
    // Ensure popup check runs even if onReady wasn't called
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<HomepageController>()) {
        final controller = Get.find<HomepageController>();
        controller.checkPersonalizationPopup();
      }
    });
    
    return _buildOriginalView(context);
  }
  
  Widget _buildOriginalView(BuildContext context) {
    final CarouselSliderController carouselController = CarouselSliderController();
    int activeIndex = 0;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            children: [
              Container(
                height: 350,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.heroGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              ListView(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.NOTIFICATION);
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.bell_fill,
                                        size: 27,
                                        color: AppColors.textOnPrimary, 
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Siap Berkembang ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textOnPrimary,
                                      ),
                                    ),
                                    Obx(() => Text(
                                      "${controller.userName.value}?",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textOnPrimary),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Stack(
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 90),
                                Container(
                                  width: double.infinity,
                                  height: 1450,
                                  decoration: const BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 120),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(horizontal: 25),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconFeatures(
                                              featureData: FeatureData(
                                                icon: Icons.article_outlined,
                                                title: "Learning",
                                                onTap: () {
                                                  Get.toNamed('/course-store-main');
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            IconFeatures(
                                              featureData: FeatureData(
                                                icon: CupertinoIcons.text_badge_checkmark,
                                                title: "Certification",
                                                width: 80,
                                                onTap: () => Get.toNamed('/certification-store-main'),
                                              ),
                                            ),
                                            
                                            const SizedBox(width: 16),
                                            IconFeatures(
                                              featureData: FeatureData(
                                                icon: CupertinoIcons.doc_text,
                                                title: "CV Assistant",
                                                width: 60,
                                                onTap: () {
                                                  Get.toNamed(Routes.CV_ASSISTANT);
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            IconFeatures(
                                              featureData: FeatureData(
                                                icon: CupertinoIcons.person_2,
                                                title: "Interview Practice",
                                                width: 60,
                                                onTap: () {
                                                  Get.toNamed('/interview-practice');
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            IconFeatures(
                                              featureData: FeatureData(
                                                icon: CupertinoIcons.briefcase,
                                                title: "Job Openings",
                                                onTap: () {
                                                  Get.toNamed(Routes.JOB_OPENINGS_MAIN);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 25),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Rekomendasi Course",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "Montserrat",
                                                    color: AppColors.textSecondary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 180,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 5,
                                              padding: const EdgeInsets.only(left: 25),
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    RekomendasiContainer(
                                                      index: index,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 25),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Rekomendasi Certification",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "Montserrat",
                                                    color: AppColors.textSecondary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            height: 180,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 5,
                                              padding: const EdgeInsets.only(left: 25),
                                              itemBuilder: (context, index) {
                                                return Row(
                                                  children: [
                                                    RekomendasiContainerCertification(
                                                      index: index,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25),
                                        child: Container(
                                          height: 90,
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.35),
                                                blurRadius: 18,
                                                offset: const Offset(0, 8),
                                              )
                                            ],
                                            gradient: LinearGradient(
                                            colors: AppColors.heroGradientSecondary,
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomCenter,
                                          ),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius: BorderRadius.circular(15)
                                                ),
                                                child: Icon(
                                                  CupertinoIcons.sparkles,
                                                  color: AppColors.textOnPrimary,
                                                  size: 29,
                                                ),
                                              ),
                                              Container(
                                                width: 190,
                                                child: Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text("Vana Plus",
                                                        style: TextStyle(
                                                        fontFamily: "Montserrat",
                                                        fontSize: 15,
                                                        color: AppColors.textOnPrimary,
                                                        fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text("Nantikan Fitur Premium yang akan datang",
                                                        style: TextStyle(
                                                          fontFamily: "Montserrat",
                                                          fontSize: 13,
                                                          color: AppColors.textOnPrimary,
                                                          fontWeight: FontWeight.w400,
                                                          ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                CupertinoIcons.arrow_right, 
                                                color: Colors.transparent,
                                                size: 25,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      StatefulBuilder(
                                        builder: (context, setState) {
                                          return Container(
                                            height: 297,
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(vertical: 15),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: AppColors.heroGradient,
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Carousel",
                                                  style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 17,
                                                    color: AppColors.textOnPrimary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Expanded(
                                                  child: CarouselSlider(
                                                    carouselController: carouselController,
                                                    options: CarouselOptions(
                                                      height: 260.0,
                                                      viewportFraction: 0.74,
                                                      autoPlay: true,
                                                      onPageChanged: (index, reason) {
                                                        setState(() {
                                                          activeIndex = index;
                                                        });
                                                      },
                                                    ),
                                                    items: [1, 2, 3, 4].map((i) {
                                                      return Builder(
                                                        builder: (BuildContext context) {
                                                          return CarouselContainer(
                                                            index: i - 1,
                                                          );
                                                        },
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                AnimatedSmoothIndicator(
                                                  activeIndex: activeIndex,
                                                  count: 4,
                                                  onDotClicked: (index) {
                                                    carouselController.animateToPage(
                                                      index,
                                                      duration: const Duration(milliseconds: 300),
                                                      curve: Curves.ease,
                                                    );
                                                  },
                                                  effect: ExpandingDotsEffect(
                                                    dotHeight: 8,
                                                    dotWidth: 8,
                                                    activeDotColor: AppColors.textOnPrimary,
                                                    dotColor: AppColors.textOnPrimary.withOpacity(0.4),
                                                    spacing: 8,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25),
                                        child: Container(
                                            height: 190,
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: AppColors.secondary,
                                              borderRadius: BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.10),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 8),
                                                )
                                              ],
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                  Routes.CAREER_ASSISTANT,
                                                  arguments: {'autofocus': true},
                                                );
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "AI Career Assistant",
                                                            style: TextStyle(
                                                              fontFamily: "Montserrat",
                                                              fontSize: 18,
                                                              color: AppColors.textOnPrimary,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 190,
                                                            child: Text(
                                                              "Berkembang Lebih Asik dengan AI Career Assistant",
                                                              style: TextStyle(
                                                                fontFamily: "Montserrat",
                                                                fontSize: 14,
                                                                color: AppColors.textOnPrimary,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 60,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                          color: AppColors.primary.withOpacity(0.3),
                                                          borderRadius: BorderRadius.circular(15)
                                                        ),
                                                        child: Icon(
                                                          CupertinoIcons.chat_bubble_2,
                                                          color: AppColors.textOnPrimary,
                                                          size: 30,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primaryContainer,
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                    child: Row(
                                                      children: [ 
                                                        Icon(
                                                          Icons.search,
                                                          color: AppColors.textSecondary,
                                                          ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "Tanya ke AI",
                                                          style: TextStyle(
                                                            fontFamily: "Montserrat",
                                                            fontSize: 14,
                                                            color: AppColors.textSecondary,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: -37,
                              left: 0,
                              right: 0,
                              child: CourseProgressCarousel(
                                courses: _getSampleCourses(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              
            ],
          ),
          BottomNavbar(currentIndex: 0)
        ],
      ),
    );
  }
}
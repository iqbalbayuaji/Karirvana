import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/styles/app_colors.dart';
import 'package:karirvana/app/shared/widgets/bottom_navbar.dart';
import '../controllers/career_assistant_controller.dart';

class CareerAssistantView extends GetView<CareerAssistantController> {
  const CareerAssistantView({super.key});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.heroGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 45),
                  child: Column(
                    children: [
                      Text(
                        "Career Assistant",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                      SizedBox(height: 100),
                      _buildUserMessage(
                        "Assalamualaikum, perkenalkan nama saya adalah wongIrengjembuten",
                        context,
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      _buildBotMessage(
                        "Waalaikumassalam, hallo wongirengjembuten. Apa yang ingin kamu tanyakan hari ini?",
                        context,
                        isWelcome: true,
                      )
                    ],
                  ),
                )
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                margin: const EdgeInsets.only(bottom: 100),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Tanyakan kawokaod',
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                        fontFamily: 'Montserrat',
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: AppColors.textSecondary,
                                        size: 20,
                                      ),
                                      suffixIcon: Icon(
                                        Icons.keyboard_voice,
                                        color: AppColors.textSecondary,
                                        size: 20,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                          color: AppColors.outline,
                                          width: 1,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: AppColors.surface,
                  )
                )
                // Container(
                //   width: double.infinity,
                //   height:60,
                //   decoration: BoxDecoration(
                //     color: AppColors.surface,
                //     borderRadius: BorderRadius.circular(15),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black.withOpacity(0.05),
                //         blurRadius: 5,
                //         offset: const Offset(0, 2),
                //       ),
                //     ],
                //   ),
                  
                // ),
              )
            ],
          ),
          BottomNavbar(currentIndex: 1),
        ],
      ),
    );
  }

  Widget _buildBotMessage(String message, BuildContext context, {bool isWelcome = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: screenWidth * 0.04),
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.85, 
              minWidth: screenWidth * 0.2,  
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              // color: AppColors.surface,
              // borderRadius: const BorderRadius.only(
              //   topLeft: Radius.circular(4),
              //   topRight: Radius.circular(20),
              //   bottomLeft: Radius.circular(20),
              //   bottomRight: Radius.circular(20),
              // ),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.1),
              //     blurRadius: 8,
              //     offset: const Offset(0, 2),
              //   ),
              // ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.closed_caption_off_rounded,
                      color: AppColors.textOnPrimary,
                      size: 25,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "Answer",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 15,
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    Flexible(
                      child: Text(
                        textAlign: TextAlign.left,
                        message,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: AppColors.textOnPrimary,
                          fontWeight: isWelcome ? FontWeight.w500 : FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserMessage(String message, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.75, 
              minWidth: screenWidth * 0.2, 
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              textAlign: TextAlign.left,
              message,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.04),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Topik Populer:',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildQuickActionChip('💼 Panduan Karir'),
            _buildQuickActionChip('📄 Review CV'),
            _buildQuickActionChip('🎯 Interview Tips'),
            _buildQuickActionChip('📊 Skill Assessment'),
            _buildQuickActionChip('💰 Negosiasi Gaji'),
            _buildQuickActionChip('🚀 Career Switch'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outline.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

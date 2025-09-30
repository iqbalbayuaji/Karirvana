import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:karirvana/app/modules/career_assistant/local_widgets/chatbot_chips.dart';
import 'package:karirvana/app/modules/career_assistant/local_widgets/roadmap_display_widget.dart';
import 'package:karirvana/app/styles/app_colors.dart';
import 'package:karirvana/app/widgets/bottom_navbar.dart';
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
                width: double.infinity,
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
                      // Header with conditional back button
                      Obx(() => Row(
                        children: [
                          if (!controller.isWelcomeView.value)
                            GestureDetector(
                              onTap: () => controller.backToWelcome(),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: AppColors.textOnPrimary,
                                  size: 24,
                                ),
                              ),
                            )
                          else
                            SizedBox(width: 40), // Placeholder when no back button
                          Expanded(
                            child: Text(
                              "Career Assistant",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.textOnPrimary,
                              ),
                            ),
                          ),
                          SizedBox(width: 40), // Balance space
                        ],
                      )),
                      SizedBox(height: 20),
                      // Conditional content based on view state
                      Obx(() => controller.isWelcomeView.value 
                        ? _buildWelcomeView(context, screenWidth, screenHeight)
                        : _buildChatView(context, screenHeight)
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                margin: const EdgeInsets.only(bottom: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Obx(() => TextFormField(
                  controller: controller.messageController,
                  focusNode: controller.inputFocusNode,
                  onFieldSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      controller.sendMessage(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: controller.isListening.value 
                      ? 'Mendengarkan...' 
                      : (controller.partialSpeechResult.value.isNotEmpty 
                          ? controller.partialSpeechResult.value 
                          : 'Tanyakan seputar karir...'),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontFamily: 'Montserrat',
                    ),
                    prefixIcon: const Icon(
                      Icons.chat_bubble_outline,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    suffixIcon: Obx(() => GestureDetector(
                      onTap: () {
                        final text = controller.messageController.text;
                        if (text.trim().isNotEmpty) {
                          controller.sendMessage(text);
                        } else if (controller.isSpeechAvailable.value) {
                          controller.toggleListening();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          controller.isListening.value 
                            ? Icons.mic 
                            : (controller.messageController.text.trim().isNotEmpty 
                                ? Icons.send 
                                : Icons.mic_none),
                          color: controller.isListening.value 
                            ? Colors.red 
                            : AppColors.primary,
                          size: 20,
                        ),
                      ),
                    )),
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
                  ),
                ))
              )
            ],
          ),
          BottomNavbar(currentIndex: 1),
        ],
      ),
    );
  }

  Widget _buildWelcomeView(BuildContext context, double screenWidth, double screenHeight) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: screenWidth * 0.3,
          ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              CupertinoIcons.chat_bubble_2,
              color: AppColors.textOnPrimary,
              size: 30,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Mau tanya apa hari ini?",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: AppColors.textOnPrimary,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.04
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 8, 
              runSpacing: 10, 
              alignment: WrapAlignment.center,
              children: [
                chatbot_chips(
                  chipsData: chatbotChipsData(name: "Roadmap Karir"),
                  onTap: () => controller.startRoadmapMode(),
                ),
                chatbot_chips(
                  chipsData: chatbotChipsData(name: "Jadwal Belajar"),
                  onTap: () => controller.sendMessage("Bagaimana cara membuat jadwal belajar yang efektif untuk pengembangan karir?"),
                ),
                chatbot_chips(
                  chipsData: chatbotChipsData(name: "konsultasi karir"),
                  onTap: () => controller.sendMessage("Saya ingin berkonsultasi tentang pilihan karir yang tepat untuk saya"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView(BuildContext context, double screenHeight) {
    return Expanded(
      child: Obx(() => ListView(
        controller: controller.scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Chat Messages
          ...controller.messages.asMap().entries.map((entry) {
            final index = entry.key;
            final message = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.03),
              child: message.isUser
                  ? _buildUserMessage(message.content, context)
                  : _buildBotMessage(message.content, context, isWelcome: index == 0),
            );
          }).toList(),
          
          // Typing Indicator
          if (controller.isTyping.value)
            _buildTypingIndicator(context),
          
          // Roadmap Display (when generated)
          if (controller.hasGeneratedRoadmap.value) ...[
            SizedBox(height: screenHeight * 0.03),
            RoadmapDisplayWidget(
              roadmapTitle: controller.roadmapTitle.value,
              roadmapDescription: controller.roadmapDescription.value,
              steps: controller.roadmapSteps,
              expandedSteps: controller.expandedSteps,
              expandedSubSteps: controller.expandedSubSteps,
              onSave: () => controller.saveRoadmap(),
              onRegenerate: () => controller.regenerateRoadmap(),
            ),
          ],
        ],
      )),
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
                    Obx(() => Icon(
                      controller.isRoadmapMode.value ? Icons.route : Icons.closed_caption_off_rounded,
                      color: AppColors.textOnPrimary,
                      size: 25,
                    )),
                    SizedBox(
                      width: 6,
                    ),
                    Obx(() => Text(
                      controller.isRoadmapMode.value ? "Roadmap Assistant" : "Answer",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 15,
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
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
              minWidth: screenWidth * 0.1, 
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

  Widget _buildTypingIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => Icon(
                  controller.isRoadmapMode.value ? Icons.route : Icons.closed_caption_off_rounded,
                  color: AppColors.textOnPrimary,
                  size: 20,
                )),
                SizedBox(width: 8),
                Obx(() => Text(
                  controller.isRoadmapMode.value ? 'Roadmap Assistant sedang mengetik...' : 'Mengetik...',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppColors.textOnPrimary.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                )),
                SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary.withOpacity(0.7)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



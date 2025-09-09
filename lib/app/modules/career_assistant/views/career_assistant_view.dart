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
                      SizedBox(height: 20),
                      Expanded(
                        child: Obx(() => ListView.builder(
                          controller: controller.scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.messages.length && controller.isTyping.value) {
                              return _buildTypingIndicator(context);
                            }
                            
                            final message = controller.messages[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                              child: message.isUser
                                  ? _buildUserMessage(message.content, context)
                                  : _buildBotMessage(message.content, context, isWelcome: index == 0),
                            );
                          },
                        )),
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
                child: TextFormField(
                  controller: controller.messageController,
                  onFieldSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      controller.sendMessage(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Tanyakan seputar karir...',
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
                    suffixIcon: GestureDetector(
                      onTap: () {
                        final text = controller.messageController.text;
                        if (text.trim().isNotEmpty) {
                          controller.sendMessage(text);
                        }
                      },
                      child: Icon(
                        Icons.keyboard_voice,
                        color: AppColors.primary,
                        size: 20,
                      ),
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
                  ),
                )
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
                Icon(
                  Icons.closed_caption_off_rounded,
                  color: AppColors.textOnPrimary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Mengetik...',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: AppColors.textOnPrimary.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
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

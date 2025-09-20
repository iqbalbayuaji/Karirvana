import 'package:get/get.dart';

import '../modules/Interview_Practice/bindings/interview_practice_binding.dart';
import '../modules/Interview_Practice/views/interview_practice_setup_view.dart';
import '../modules/Interview_Practice_Chat/bindings/interview_practice_chat_binding.dart';
import '../modules/Interview_Practice_Chat/views/interview_practice_chat_view.dart';
import '../modules/Interview_Practice_Feedback/bindings/interview_practice_feedback_binding.dart';
import '../modules/Interview_Practice_Feedback/views/interview_practice_feedback_view.dart';
import '../modules/Interview_Practice_History/bindings/interview_practice_history_binding.dart';
import '../modules/Interview_Practice_History/views/interview_practice_history_view.dart';
import '../modules/Interview_Practice_History_Chat/bindings/interview_practice_history_chat_binding.dart';
import '../modules/Interview_Practice_History_Chat/views/interview_practice_history_chat_view.dart';
import '../modules/career_assistant/bindings/career_assistant_binding.dart';
import '../modules/career_assistant/views/career_assistant_view.dart';
import '../modules/certification_store_main/bindings/certification_store_main_binding.dart';
import '../modules/certification_store_main/views/certification_store_main_view.dart';
import '../modules/course_store/bindings/course_store_binding.dart';
import '../modules/course_store/views/course_store_view.dart';
import '../modules/course_store_main/bindings/course_store_main_binding.dart';
import '../modules/course_store_main/views/course_store_main_view.dart';
import '../modules/course_user/bindings/course_user_binding.dart';
import '../modules/course_user/views/course_user_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/homepage/bindings/homepage_binding.dart';
import '../modules/homepage/views/homepage_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/personalization/bindings/personalization_binding.dart';
import '../modules/personalization/views/personalization_view.dart';
import '../modules/profile_user/bindings/profile_user_binding.dart';
import '../modules/profile_user/views/profile_user_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOMEPAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOMEPAGE,
      page: () => const HomepageView(),
      binding: HomepageBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.COURSE_STORE,
      page: () => const CourseStoreView(),
      binding: CourseStoreBinding(),
    ),
    GetPage(
      name: _Paths.COURSE_USER,
      page: () => const CourseUserView(),
      binding: CourseUserBinding(),
    ),
    GetPage(
      name: _Paths.COURSE_STORE_MAIN,
      page: () => const CourseStoreMainView(),
      binding: CourseStoreMainBinding(),
    ),
    GetPage(
      name: _Paths.CERTIFICATION_STORE_MAIN,
      page: () => const CertificationStoreMainView(),
      binding: CertificationStoreMainBinding(),
    ),
    GetPage(
      name: _Paths.CAREER_ASSISTANT,
      page: () => const CareerAssistantView(),
      binding: CareerAssistantBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_USER,
      page: () => const ProfileUserView(),
      binding: ProfileUserBinding(),
    ),
    GetPage(
      name: _Paths.PERSONALIZATION,
      page: () => const PersonalizationView(),
      binding: PersonalizationBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.INTERVIEW_PRACTICE,
      page: () => const InterviewPracticeView(),
      binding: InterviewPracticeBinding(),
    ),
    GetPage(
      name: _Paths.INTERVIEW_PRACTICE_CHAT,
      page: () => const InterviewPracticeChatView(),
      binding: InterviewPracticeChatBinding(),
    ),
    GetPage(
      name: _Paths.INTERVIEW_PRACTICE_FEEDBACK,
      page: () => const InterviewPracticeFeedbackView(),
      binding: InterviewPracticeFeedbackBinding(),
    ),
    GetPage(
      name: _Paths.INTERVIEW_PRACTICE_HISTORY,
      page: () => const InterviewPracticeHistoryView(),
      binding: InterviewPracticeHistoryBinding(),
    ),
    GetPage(
      name: _Paths.INTERVIEW_PRACTICE_HISTORY_CHAT,
      page: () => const InterviewPracticeHistoryChatView(),
      binding: InterviewPracticeHistoryChatBinding(),
    ),
  ];
}

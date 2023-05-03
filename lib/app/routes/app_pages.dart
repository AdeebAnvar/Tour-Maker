import 'package:flutter/animation.dart';

import 'package:get/get.dart';

import '../modules/Booking_summary/bindings/booking_summary_binding.dart';
import '../modules/Booking_summary/views/booking_summary_view.dart';
import '../modules/add_passenger/bindings/add_passenger_binding.dart';
import '../modules/add_passenger/views/add_passenger_view.dart';
import '../modules/booking_screen/bindings/booking_screen_binding.dart';
import '../modules/booking_screen/views/booking_screen_view.dart';
import '../modules/checkout_screen/bindings/checkout_screen_binding.dart';
import '../modules/checkout_screen/views/checkout_screen_view.dart';
import '../modules/exclusive_tours/bindings/exclusive_tours_binding.dart';
import '../modules/exclusive_tours/views/exclusive_tours_view.dart';
import '../modules/favourites_screen/bindings/favourites_screen_binding.dart';
import '../modules/favourites_screen/views/favourites_screen_view.dart';
import '../modules/filter_screen/bindings/filter_screen_binding.dart';
import '../modules/filter_screen/views/filter_screen_view.dart';
import '../modules/get_started/bindings/get_started_binding.dart';
import '../modules/get_started/views/get_started_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/invoice_pdf/bindings/invoice_pdf_binding.dart';
import '../modules/invoice_pdf/views/invoice_pdf_view.dart';
import '../modules/jnnjf/bindings/jnnjf_binding.dart';
import '../modules/jnnjf/views/jnnjf_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/lucky_draw/bindings/lucky_draw_binding.dart';
import '../modules/lucky_draw/views/lucky_draw_view.dart';
import '../modules/main_screen/bindings/main_screen_binding.dart';
import '../modules/main_screen/views/main_screen_view.dart';
import '../modules/nointernet/bindings/nointernet_binding.dart';
import '../modules/nointernet/views/nointernet_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/otp_screen/bindings/otp_screen_binding.dart';
import '../modules/otp_screen/views/otp_screen_view.dart';
import '../modules/payment_screen/bindings/payment_screen_binding.dart';
import '../modules/payment_screen/views/payment_screen_view.dart';
import '../modules/payment_summary/bindings/payment_summary_binding.dart';
import '../modules/payment_summary/views/payment_summary_view.dart';
import '../modules/pdf_view/bindings/pdf_view_binding.dart';
import '../modules/pdf_view/views/pdf_view_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/rewards/bindings/rewards_binding.dart';
import '../modules/rewards/views/rewards_view.dart';
import '../modules/search_details/bindings/search_details_binding.dart';
import '../modules/search_details/views/search_details_view.dart';
import '../modules/search_view/bindings/search_view_binding.dart';
import '../modules/search_view/views/search_view_view.dart';
import '../modules/single_category/bindings/single_category_binding.dart';
import '../modules/single_category/views/single_category_view.dart';
import '../modules/single_passenger/bindings/single_passenger_binding.dart';
import '../modules/single_passenger/views/single_passenger_view.dart';
import '../modules/single_tour/bindings/single_tour_binding.dart';
import '../modules/single_tour/views/single_tour_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/terms_and_conditions/bindings/terms_and_conditions_binding.dart';
import '../modules/terms_and_conditions/views/terms_and_conditions_view.dart';
import '../modules/token_screen/bindings/token_screen_binding.dart';
import '../modules/token_screen/views/token_screen_view.dart';
import '../modules/tours_view/bindings/tours_view_binding.dart';
import '../modules/tours_view/views/tours_view_view.dart';
import '../modules/travel_types/bindings/travel_types_binding.dart';
import '../modules/travel_types/views/travel_types_view.dart';
import '../modules/travellers_screen/bindings/travellers_screen_binding.dart';
import '../modules/travellers_screen/views/travellers_screen_view.dart';
import '../modules/trending_tours/bindings/trending_tours_binding.dart';
import '../modules/trending_tours/views/trending_tours_view.dart';
import '../modules/user_registerscreen/bindings/user_registerscreen_binding.dart';
import '../modules/user_registerscreen/views/user_registerscreen_view.dart';

// ignore_for_file: always_specify_types

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const String INITIAL = Routes.SPLASH_SCREEN;

  static final List<GetPage<dynamic>> routes = <GetPage<dynamic>>[
    GetPage<dynamic>(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.leftToRightWithFade,
      curve: Curves.easeInOut,
      name: _Paths.GET_STARTED,
      page: () => const GetStartedView(),
      binding: GetStartedBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.rightToLeftWithFade,
      curve: Curves.easeInOut,
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.MAIN_SCREEN,
      page: () => const MainScreenView(),
      binding: MainScreenBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.fade,
      curve: Curves.easeInOut,
      name: _Paths.OTP_SCREEN,
      page: () => const OtpScreenView(),
      binding: OtpScreenBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.rightToLeft,
      curve: Curves.easeInOut,
      name: _Paths.TERMS_AND_CONDITIONS,
      page: () => const TermsAndConditionsView(),
      binding: TermsAndConditionsBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.LUCKY_DRAW,
      page: () => const LuckyDrawView(),
      binding: LuckyDrawBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.topLevel,
      curve: Curves.easeInOut,
      name: _Paths.PAYMENT_SCREEN,
      page: () => const PaymentScreenView(),
      binding: PaymentScreenBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.FAVOURITES_SCREEN,
      page: () => const FavouritesScreenView(),
      binding: FavouritesScreenBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.BOOKING_SCREEN,
      page: () => const BookingScreenView(),
      binding: BookingScreenBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.FILTER_SCREEN,
      page: () => const FilterScreenView(),
      binding: FilterScreenBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.circularReveal,
      curve: Curves.easeInOut,
      name: _Paths.SEARCH_VIEW,
      page: () => const SearchViewView(),
      binding: SearchViewBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.TOKEN_SCREEN,
      page: () => const TokenScreenView(),
      binding: TokenScreenBinding(),
    ),
    GetPage<dynamic>(
      transition: Transition.fade,
      curve: Curves.easeInOut,
      name: _Paths.REWARDS,
      page: () => const RewardsView(),
      binding: RewardsBinding(),
    ),
    GetPage(
      transition: Transition.leftToRightWithFade,
      curve: Curves.bounceIn,
      name: _Paths.SINGLE_TOUR,
      page: () => const SingleTourView(),
      binding: SingleTourBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.SINGLE_CATEGORY,
      page: () => const SingleCategoryView(),
      binding: SingleCategoryBinding(),
    ),
    GetPage(
      transition: Transition.leftToRightWithFade,
      curve: Curves.easeInOut,
      name: _Paths.SEARCH_DETAILS,
      page: () => const SearchDetailsView(),
      binding: SearchDetailsBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.NOINTERNET,
      page: () => const NointernetView(),
      binding: NointernetBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.TOURS_VIEW,
      page: () => const ToursViewView(),
      binding: ToursViewBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.ADD_PASSENGER,
      page: () => const AddPassengerView(),
      binding: AddPassengerBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.PDF_VIEW,
      page: () => const PdfViewView(),
      binding: PdfViewBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      transitionDuration: const Duration(milliseconds: 400),
      name: _Paths.USER_REGISTERSCREEN,
      page: () => const UserRegisterscreenView(),
      binding: UserRegisterscreenBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.TRENDING_TOURS,
      page: () => const TrendingToursView(),
      binding: TrendingToursBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.EXCLUSIVE_TOURS,
      page: () => const ExclusiveToursView(),
      binding: ExclusiveToursBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.TRAVEL_TYPES,
      page: () => const TravelTypesView(),
      binding: TravelTypesBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.CHECKOUT_SCREEN,
      page: () => const CheckoutScreenView(),
      binding: CheckoutScreenBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.TRAVELLERS_SCREEN,
      page: () => const TravellersScreenView(),
      binding: TravellersScreenBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.SINGLE_PASSENGER,
      page: () => const SinglePassengerView(),
      binding: SinglePassengerBinding(),
    ),
    GetPage(
      transition: Transition.downToUp,
      curve: Curves.easeInOut,
      name: _Paths.PAYMENT_SUMMARY,
      page: () => const PaymentSummaryView(),
      binding: PaymentSummaryBinding(),
    ),
    GetPage(
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      name: _Paths.BOOKING_SUMMARY,
      page: () => const BookingSummaryView(),
      binding: BookingSummaryBinding(),
    ),
    GetPage(
      name: _Paths.INVOICE_PDF,
      page: () => const InvoicePdfView(),
      binding: InvoicePdfBinding(),
    ),
    GetPage(
      name: _Paths.JNNJF,
      page: () => const JnnjfView(),
      binding: JnnjfBinding(),
    ),
  ];
}

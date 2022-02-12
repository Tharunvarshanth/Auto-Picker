import 'package:auto_picker/components/organisms/mechanic_profile.dart';
import 'package:auto_picker/components/pages/add_new_advertisement.dart';
import 'package:auto_picker/components/pages/advertisement_listing_page.dart';
import 'package:auto_picker/components/pages/google_signin_login_page.dart';
import 'package:auto_picker/components/pages/login_page.dart';
import 'package:auto_picker/components/pages/map_page.dart';
import 'package:auto_picker/components/pages/mechanics_signup_page.dart';
import 'package:auto_picker/components/pages/menu_more_page.dart';
import 'package:auto_picker/components/pages/notification_page.dart';
import 'package:auto_picker/components/pages/otp_login_page.dart';
import 'package:auto_picker/components/pages/otp_signup_page.dart';
import 'package:auto_picker/components/pages/profile_page.dart';
import 'package:auto_picker/components/pages/seller_signup_page.dart';
import 'package:auto_picker/components/pages/sign_up_page.dart';
import 'package:auto_picker/components/pages/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/pages/advertisement_payment_page.dart';
import 'components/pages/home_page.dart';
import 'components/pages/mechanic_profile_page.dart';
import 'components/pages/mechanics_listing_page.dart';
import 'components/pages/orders_seller_page.dart';
import 'components/pages/product_listing_page.dart';
import 'components/pages/product_page.dart';
import 'components/pages/profile_user_edit_page.dart';
import 'components/pages/test_page.dart';

class RouteGenerator {
  static const String splash = "/";
  static const String homePage = '/home';
  static const String testPage = '/test';
  static const String loginPage = '/login';
  static const String signUpPage = '/signup';
  static const String otpSignup = '/otpSignup';
  static const String otpLogin = '/otpLogin';
  static const String mechanicsSignUp = '/mechanicsSignup';
  static const String sellerSignup = '/sellerSignUp';
  static const String mapLatLonGetter = '/mapLatLonGetter';
  static const String googleLinkLogin = '/googleLinkLogin';
  static const String profilePage = '/profilePage';
  static const String addNewAdvertisement = '/addNewAdvertisementPage';
  static const String advertisementPaymentPage = '/advertisementPaymentPage';
  static const String menuMorePage = '/menuMorePage';
  static const String mechanicsListingPage = '/mechanicsListingPage';
  static const String productsListingPage = '/productsListingPage';
  static const String productPage = '/productPage';
  static const String mechanicProfilePage = '/mechanicProfilePage';
  static const String userProfileEditPage = '/userProfileEditPage';
  static const String advertisementListingPage = '/advertisementListingPage';
  static const String orderSellerPage = "/orderPage";
  static const String notificationsPage = '/notificationPage';

  RouteGenerator._() {}

  // Expose a key to use a navigator without a context
  static final key = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case loginPage:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signUpPage:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case otpSignup:
        return MaterialPageRoute(builder: (_) => const OtpSignUpPage());
      case otpLogin:
        return MaterialPageRoute(builder: (_) => const OtpLoginPage());
      case mechanicsSignUp:
        return MaterialPageRoute(builder: (_) => const MechanicsSignUpPage());
      case sellerSignup:
        return MaterialPageRoute(builder: (_) => const SellerSignUpPage());
      case mapLatLonGetter:
        return MaterialPageRoute(builder: (_) => MapLatLonPage());
      case googleLinkLogin:
        return MaterialPageRoute(builder: (_) => const GoogleLinkingPage());
      case profilePage:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case addNewAdvertisement:
        return MaterialPageRoute(
            builder: (_) => const AddNewAdvertisementPage());
      case advertisementPaymentPage:
        return MaterialPageRoute(
            builder: (_) => const AdvertisementPaymentPage());
      case menuMorePage:
        return MaterialPageRoute(builder: (_) => const MenuMorePage());
      case mechanicsListingPage:
        return MaterialPageRoute(builder: (_) => const MechanicsListingPage());
      case productsListingPage:
        return MaterialPageRoute(builder: (_) => const ProductListingPage());
      case productPage:
        return MaterialPageRoute(builder: (_) => ProductPage());
      case mechanicProfilePage:
        return MaterialPageRoute(builder: (_) => MechanicProfilePage());
      case userProfileEditPage:
        return MaterialPageRoute(builder: (_) => ProfileUserEditPage());
      case advertisementListingPage:
        return MaterialPageRoute(builder: (_) => AdvertisementListingPage());
      case orderSellerPage:
        return MaterialPageRoute(builder: (_) => const OrdersSellerListPage());
      case notificationsPage:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case testPage:
        return MaterialPageRoute(builder: (_) => const TestPage());
      default:
        throw FormatException("Route not found");
    }
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}

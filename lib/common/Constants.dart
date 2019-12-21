 import 'package:flutter/cupertino.dart';

class Constants {
  static final String BASE_URL = "https://floating-brushlands-52313.herokuapp.com";
  static final String LOGIN_URL = "/authentication/login";
  static final String REGISTRATION_URL = "/authentication/register";
  static BuildContext applicationContext;

  // APPLICATION NAME
  static final String APPLICATION_NAME = "Shikshatam";

  // Component Data
  static final String EMAIL_HINT = "Email *";
  static final String FIRST_NAME_HINT = "First Name *";
  static final String LAST_NAME_HINT = "Last Name *";
  static final String PASSWORD_HINT = "Password *";
  static final String CONFIRM_PASSWORD_HINT = "Confirm Password *";
  static final String MOBILE_HINT = "Mobile *";
  static final String ADDRESS1_HINT = "Address 1 *";
  static final String ADDRESS2_HINT = "Address 2 *";
  static final String CITY_HINT = "City *";
  static final String STATE_HINT = "State *";
  static final String COUNTRY_HINT = "Country *";
  static final String PINCODE_HINT = "Pincode *";
  static final String REGISTER_BUTTON_HINT = "REGISTER";
  static final String LOGIN_BUTTON = "LOGIN";
  static final String REGISTRATION_PAGE = "Registration";
  static final String LOGIN_PAGE = "Login";
  static final String LOGOUT_BUTTON = "Logout";
  static final String NOTIFIC_BUTTON = "Logout";

  // VALIDATION HINT
  static final String FIRST_NAME_VALIDATION = "Enter Your First Name ";
  static final String LAST_NAME_VALIDATION = "Enter Your Last Name ";
  static final String EMAIL_VALIDATION = "Not a Valid Email ";
  static final String PASSWORD_VALIDATION = "Password Too Short ";
  static final String CONFIRM_PASSWORD_VALIDATION = "Password Not Matched ";
  static final String MOBILE_VALIDATION = "Enter Correct Number";
  static final String ADDRESS1_VALIDATION = "Enter Address1";
  static final String ADDRESS2_VALIDATION = "Enter Address2";
  static final String CITY_VALIDATION = "Enter City";
  static final String STATE_VALIDATION = "Enter State";
  static final String COUNTRY_VALIDATION = "Enter Country";
  static final String PINCODE_VALIDATION = "Enter Correct Pincode";

  // TOAST MESSAGES
  static final String USER_ALREADY = "Please use Diffrent email ID ,User already registered";
  static final String USER_REGISTER = "User registered";
  static final String INCORRECT_PASSWORD = "Incorrect Email And Password";


 }
class ApiUrl {
  static String baseUrl = "http://97.74.93.130:3001/agni";
  static String customerSignUp = "$baseUrl/CustomerSignUp";
  static String customerSignIn = "$baseUrl/CustomerSignIn";
  static String schemeList = "$baseUrl/SchemeList";
  static String rateMastUpdate = "$baseUrl/RateMastUpdate";
  static String customerCheck({required String mobileNumber}) {
    return "$baseUrl/CustomerCheck?MOBILENO=$mobileNumber";
  }
}

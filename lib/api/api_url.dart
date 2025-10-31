class ApiUrl {
  static String baseUrl = "http://97.74.93.130:3001/agni";
  static String customerSignUp = "$baseUrl/CustomerSignUp";
  static String customerSignIn = "$baseUrl/CustomerSignIn";
  static String otpSend = "$baseUrl/otp/send";
  static String otpVerify = "$baseUrl/otp/verify";
  static String schemeList = "$baseUrl/SchemeList";
  static String rateMastUpdate = "$baseUrl/RateMastUpdate";
  static String schemeJoin = "$baseUrl/SchemeJoin";


  static String customerCheck({required String mobileNumber}) {
    return "$baseUrl/CustomerCheck?MOBILENO=$mobileNumber";
  }
  static String mySchemeList({required String mobileNumber}) {
    return "$baseUrl/SchemeJoinList?MOBILENO=$mobileNumber&ACCNO=";
  }

  static String transactionHistory({required String mobileNumber}) {
    return "$baseUrl/scheme/trasaction?MOBILENO=$mobileNumber";
  }

  static String myLedger({
    required String mobileNumber,
    required String accNo,
  }) {
    return "$baseUrl/SchemeJoinList?MOBILENO=$mobileNumber&ACCNO=$accNo";
  }
}

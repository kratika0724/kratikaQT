class ApiPath{

  static const String baseUrl = 'https://api.qtcollector.com/api';
  static const String baseUrlint = 'http://192.168.1.13:3005/api';
  static const String verifyOtp = '/qt/agents/verifyOtp';
  static const String sendOtp = '/qt/agents/sendOtp';

  // static const String imageURL = 'https://api.qtcollector.com/uploads/images/';


  static const String getDashboardData = '/qt/ds/dashboard';


  static const String createProduct = '/qt/product/create';
  static const String createCustomer = '/qt/customer/create';
  static const String createAgent = '/qt/agents/create';
  static const String createAllocation = '/qt/allocation/create';


  static const String getProduct = '/qt/product/getList';
  static const String getAgent = '/qt/agents/getList';
  static const String getAllocation = '/qt/allocation/getList';
  static const String getCustomer = '/qt/customer/getList';
  static const String getTransactions = '/qt/transaction/getList';


  static const String getVendorPayments = '/qt/vendorPayment/getList';

  static const String getAgentByArea = '/qt/agents/getListByArea';


}
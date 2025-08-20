class ApiPath {
  static const String baseUrl = 'http://192.168.1.11:3001/api';
  static const String baseUrlint = 'http://192.168.1.11:3001/api';

  // static const String imageURL = 'https://api.qtcollector.com/uploads/images/';

  static const String getDashboardData = '/qt/ds/dashboard';
  static const String getDatabyId = '/qt/wallet/getDataById';

  static const String verifyOtp = '/qt/user/verifyOtp';
  static const String sendOtp = '/qt/user/sendOtp';

  static const String createProduct = '/qt/product/create';
  static const String createCustomer = '/qt/customer/create';
  static const String createAgent = '/qt/agents/create';
  static const String createAllocation = '/qt/allocation/create';

  static const String getProduct = '/qt/product/getList';
  static const String getAgent = '/qt/user/getList';
  static const String getAllocation = '/qt/allocation/getList';
  static const String getCustomer = '/qt/customer/getList';
  static const String getTransactions = '/qt/transaction/getList';
  static const String getPendingBills = '/qt/wallet/pendingbills';

  static const String getVendorPayments = '/qt/vendorPayment/getList';

  static const String getAgentByArea = '/qt/user/getListByArea';

  static const String cashBalance = '/qt/wallet/cashBalance';
}

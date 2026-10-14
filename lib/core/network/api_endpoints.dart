class ApiEndpoints {
  static const String baseUrl =
      'https://4234cwc7-8004.inc1.devtunnels.ms/api/v1/';

  // Compatibility aliases
  static const String login = authSignIn;
  static const String register = authRegister;
  static const String quotes = 'quotes/';

  /// Authentication Endpoints
  static const String authRegister = 'auth/register/';
  static const String authResendVerificationCode =
      'auth/resend-verification-code/';
  static const String authVerifyEmail = 'auth/verify-email/';
  static const String authSignIn = 'auth/signin/';
  static const String authForgotPassword = 'auth/forgot-password/';
  static const String authVerifyResetCode = 'auth/verify-reset-code/';
  static const String authResetPassword = 'auth/reset-password/';
  static const String authRefreshToken = 'auth/refresh-token/';
  static const String refreshToken = authRefreshToken;
  static const String authChangePassword = 'auth/change-password/';
  static const String authDeleteAccount = 'auth/delete-account/';
  static const String authMe = 'auth/me';

  /// Admin Endpoints
  static const String adminCategories = 'admin/categories/';
  static const String adminProviderListProfile =
      'Provider/provider-list-profile/';

  /// Provider Endpoints
  static const String providerDashboard = 'Provider/dashboard/';
  static const String providerWallet = 'Provider/provider-wallet/';
  static const String providerFinanceTransactions =
      'Provider/finance/transactions/';
  static const String providerPayoutMethods = 'Provider/payout-methods/';
  static const String providerPayoutsPreview = 'Provider/payouts/preview/';
  static const String providerPayouts = 'Provider/payouts/';
  static const String providerConnectOnboarding =
      'Provider/connect/onboarding/';
  static const String providerConnectStatus = 'Provider/connect/status/';
  static const String providerConnectDashboard = 'Provider/connect/dashboard/';
  static const String providerBookingsCounts = 'Provider/services-bookings-counts';
  static const String providerBookingsList = 'Provider/services-bookings-list';
  static const String providerServiceBookingDetails = 'Provider/services-bookings/';
  static const String providerServiceAccept = 'Provider/service-accept/';
  static const String providerServiceReject = 'Provider/service-reject/';
  static const String providerCategoriesList = 'Provider/categories-list/';
  static const String providerCoachProfile = 'Provider/coach-profile/';
  static const String providerServicesCreate = 'Provider/services/create/';
  static const String providerServicesRetrieve = 'Provider/retrive-services/';
  static const String providerServicesList = 'Provider/services/list/';
  static const String providerServices = 'Provider/services/';
  static const String providerBlogsCreate = 'Provider/blogs/create/';
  static const String providerBlogs = 'Provider/blogs/';
  static const String providerProductsCreate = 'Provider/products/create/';
  static const String providerProductsList = 'Provider/products-list/';
  static const String providerProducts = 'Provider/products/';
  static const String providerClientNeeds = 'Provider/client-needs/';
  static const String providerClientNeedAccept = 'Provider/client-needs/';
  static const String providerAvailability = 'Provider/availability/';
  static const String providerAffiliateLink = 'Provider/affiliate-link';
  static const String providerAffiliates = 'Provider/affiliates';

  /// Payments Endpoints
  static const String paymentsBookings = 'payments/bookings/';
  static const String paymentsBookingsReject = 'payments/bookings/';
  static const String paymentsProductsPurchase = 'payments/products/purchase/';
  static const String paymentsBookService = 'payments/book-service/';
  static const String paymentsOrders = 'payments/orders/';
  static const String paymentsStripeCheckout =
      'payments/stripe/create-checkout-session/';
  static const String paymentsSessionReports = 'payments/session-reports/';
  static const String paymentsQuote = 'payments/quote/';
  static const String paymentsOnCallRequests = 'payments/on-call/requests/';

  /// User / Client Endpoints
  static const String userCategoryList = 'user/user-category-list/';
  static const String userBookingList = 'user/user-booking-list/';
  static const String userBookingReschedule = 'user/user-booking-reschedule/';
  static const String userBookingCancel = 'user/user-booking-cancel/';
  static const String userCoachProfileList = 'user/coach-profile-list/';
  static const String userCoachProfileDetail = 'user/coach-profile/';
  static const String userDigitalProductList = 'user/digital-product-list/';
  static const String userDigitalProductDetail = 'user/digital-product-detail/';
  static const String userServiceList = 'user/user-service-list/';
  static const String userServiceDetail = 'user/user-service-detail/';
  static const String userProductsList = 'Provider/user-products-list/';
  static const String userPurchasedProductList = 'user/user-product-list';
  static const String userPurchasedProductDetail = 'user/user-product-detail/';
  static const String userRecommendedCoachProfileList =
      'user/recommended-coach-profile-list/';
  static const String userBlogList = 'user/blog-list/';
  static const String userBlogDetail = 'user/blog-detail/';
  static const String userAppRatingsList = 'user/app-ratings-list/';
  static const String userCoachProfileReview = 'user/coach-profile-review/';
  static const String userAppRating = 'user/app-rating/';
  static const String userCoachAvailability = 'user/coaches/';
  static const String userCoachAffiliate = 'user/coaches/';
  static const String userAffiliates = 'user/affiliates/';
  static const String createUserPost = 'user/create-user-post/';
  static const String userFavorites = 'user/favorites/';
  static const String userMyPosts = 'user/my-posts/';
  static const String userBillingHistory = 'user/billing-history/';

  /// Message & Chat Endpoints
  static const String messagesConversations = 'messages/conversations/';
  static const String messagesConversationStart = 'messages/conversations/start/';
  static const String messagesConversationDetail = 'messages/conversations/';
  static const String messagesConversationMessages = 'messages/conversations/';
  static const String messagesConversationSend = 'messages/conversations/';
  static const String messagesConversationRead = 'messages/conversations/';
  static const String messagesUnreadCount = 'messages/unread-count/';
  static const String messagesDelete = 'messages/messages/';
  static const String wsChat = 'ws/chat/';
  static const String wsNotifications = 'ws/notifications/';

  static String get wsBaseUrl {
    final uri = Uri.parse(baseUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final portStr = uri.hasPort ? ':${uri.port}' : '';
    return '$wsScheme://${uri.host}$portStr';
  }

  static String wsChatUrl(dynamic conversationId, String token) =>
      '$wsBaseUrl/$wsChat$conversationId/?token=${Uri.encodeComponent(token)}';

  static String wsNotificationsUrl(String token) =>
      '$wsBaseUrl/$wsNotifications?token=${Uri.encodeComponent(token)}';

  /// Notification Endpoints
  static const String notifications = 'notifications';
  static const String notificationsUnreadCount = 'notifications/unread-count';
  static const String notificationsReadAll = 'notifications/read-all';
  static const String notificationSettings = 'notifications/settings';

  /// Public Endpoints (No Auth Header required)
  static const List<String> noAuthEndpoints = [
    authRegister,
    authResendVerificationCode,
    authVerifyEmail,
    authSignIn,
    authForgotPassword,
    authVerifyResetCode,
    authResetPassword,
    authRefreshToken,
    providerCategoriesList,
  ];
}

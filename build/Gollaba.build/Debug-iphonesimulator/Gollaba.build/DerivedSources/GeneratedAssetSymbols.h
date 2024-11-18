#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"com.kihyeon.Gollaba";

/// The "AttachImageColor" asset catalog color resource.
static NSString * const ACColorNameAttachImageColor AC_SWIFT_PRIVATE = @"AttachImageColor";

/// The "CalendarColor" asset catalog color resource.
static NSString * const ACColorNameCalendarColor AC_SWIFT_PRIVATE = @"CalendarColor";

/// The "CopyrightColor" asset catalog color resource.
static NSString * const ACColorNameCopyrightColor AC_SWIFT_PRIVATE = @"CopyrightColor";

/// The "EnrollButtonColor" asset catalog color resource.
static NSString * const ACColorNameEnrollButtonColor AC_SWIFT_PRIVATE = @"EnrollButtonColor";

/// The "MainTitleFontColor" asset catalog color resource.
static NSString * const ACColorNameMainTitleFontColor AC_SWIFT_PRIVATE = @"MainTitleFontColor";

/// The "OAuthLoginButtonBorderColor" asset catalog color resource.
static NSString * const ACColorNameOAuthLoginButtonBorderColor AC_SWIFT_PRIVATE = @"OAuthLoginButtonBorderColor";

/// The "PollContentInfoFontColor" asset catalog color resource.
static NSString * const ACColorNamePollContentInfoFontColor AC_SWIFT_PRIVATE = @"PollContentInfoFontColor";

/// The "PollContentTitleBackgroundColor" asset catalog color resource.
static NSString * const ACColorNamePollContentTitleBackgroundColor AC_SWIFT_PRIVATE = @"PollContentTitleBackgroundColor";

/// The "PollContentTitleFontColor" asset catalog color resource.
static NSString * const ACColorNamePollContentTitleFontColor AC_SWIFT_PRIVATE = @"PollContentTitleFontColor";

/// The "SearchBorderColor" asset catalog color resource.
static NSString * const ACColorNameSearchBorderColor AC_SWIFT_PRIVATE = @"SearchBorderColor";

/// The "SelectedPollColor" asset catalog color resource.
static NSString * const ACColorNameSelectedPollColor AC_SWIFT_PRIVATE = @"SelectedPollColor";

/// The "ToolbarBackgroundColor" asset catalog color resource.
static NSString * const ACColorNameToolbarBackgroundColor AC_SWIFT_PRIVATE = @"ToolbarBackgroundColor";

/// The "AnonymousIcon" asset catalog image resource.
static NSString * const ACImageNameAnonymousIcon AC_SWIFT_PRIVATE = @"AnonymousIcon";

/// The "AppIconImage" asset catalog image resource.
static NSString * const ACImageNameAppIconImage AC_SWIFT_PRIVATE = @"AppIconImage";

/// The "KakaoIcon" asset catalog image resource.
static NSString * const ACImageNameKakaoIcon AC_SWIFT_PRIVATE = @"KakaoIcon";

/// The "NaverIcon" asset catalog image resource.
static NSString * const ACImageNameNaverIcon AC_SWIFT_PRIVATE = @"NaverIcon";

/// The "OnlyPollIcon" asset catalog image resource.
static NSString * const ACImageNameOnlyPollIcon AC_SWIFT_PRIVATE = @"OnlyPollIcon";

/// The "PluralIcon" asset catalog image resource.
static NSString * const ACImageNamePluralIcon AC_SWIFT_PRIVATE = @"PluralIcon";

/// The "QuestionIcon" asset catalog image resource.
static NSString * const ACImageNameQuestionIcon AC_SWIFT_PRIVATE = @"QuestionIcon";

/// The "Search" asset catalog image resource.
static NSString * const ACImageNameSearch AC_SWIFT_PRIVATE = @"Search";

/// The "SignIcon" asset catalog image resource.
static NSString * const ACImageNameSignIcon AC_SWIFT_PRIVATE = @"SignIcon";

#undef AC_SWIFT_PRIVATE

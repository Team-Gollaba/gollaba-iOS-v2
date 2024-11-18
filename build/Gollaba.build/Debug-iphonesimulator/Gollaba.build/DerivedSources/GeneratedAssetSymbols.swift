import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

    /// The "AttachImageColor" asset catalog color resource.
    static let attach = DeveloperToolsSupport.ColorResource(name: "AttachImageColor", bundle: resourceBundle)

    /// The "CalendarColor" asset catalog color resource.
    static let calendar = DeveloperToolsSupport.ColorResource(name: "CalendarColor", bundle: resourceBundle)

    /// The "CopyrightColor" asset catalog color resource.
    static let copyright = DeveloperToolsSupport.ColorResource(name: "CopyrightColor", bundle: resourceBundle)

    /// The "EnrollButtonColor" asset catalog color resource.
    static let enrollButton = DeveloperToolsSupport.ColorResource(name: "EnrollButtonColor", bundle: resourceBundle)

    /// The "MainTitleFontColor" asset catalog color resource.
    static let mainTitleFont = DeveloperToolsSupport.ColorResource(name: "MainTitleFontColor", bundle: resourceBundle)

    /// The "OAuthLoginButtonBorderColor" asset catalog color resource.
    static let oAuthLoginButtonBorder = DeveloperToolsSupport.ColorResource(name: "OAuthLoginButtonBorderColor", bundle: resourceBundle)

    /// The "PollContentInfoFontColor" asset catalog color resource.
    static let pollContentInfoFont = DeveloperToolsSupport.ColorResource(name: "PollContentInfoFontColor", bundle: resourceBundle)

    /// The "PollContentTitleBackgroundColor" asset catalog color resource.
    static let pollContentTitleBackground = DeveloperToolsSupport.ColorResource(name: "PollContentTitleBackgroundColor", bundle: resourceBundle)

    /// The "PollContentTitleFontColor" asset catalog color resource.
    static let pollContentTitleFont = DeveloperToolsSupport.ColorResource(name: "PollContentTitleFontColor", bundle: resourceBundle)

    /// The "SearchBorderColor" asset catalog color resource.
    static let searchBorder = DeveloperToolsSupport.ColorResource(name: "SearchBorderColor", bundle: resourceBundle)

    /// The "SelectedPollColor" asset catalog color resource.
    static let selectedPoll = DeveloperToolsSupport.ColorResource(name: "SelectedPollColor", bundle: resourceBundle)

    /// The "ToolbarBackgroundColor" asset catalog color resource.
    static let toolbarBackground = DeveloperToolsSupport.ColorResource(name: "ToolbarBackgroundColor", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "AnonymousIcon" asset catalog image resource.
    static let anonymousIcon = DeveloperToolsSupport.ImageResource(name: "AnonymousIcon", bundle: resourceBundle)

    /// The "AppIconImage" asset catalog image resource.
    static let appIcon = DeveloperToolsSupport.ImageResource(name: "AppIconImage", bundle: resourceBundle)

    /// The "KakaoIcon" asset catalog image resource.
    static let kakaoIcon = DeveloperToolsSupport.ImageResource(name: "KakaoIcon", bundle: resourceBundle)

    /// The "NaverIcon" asset catalog image resource.
    static let naverIcon = DeveloperToolsSupport.ImageResource(name: "NaverIcon", bundle: resourceBundle)

    /// The "OnlyPollIcon" asset catalog image resource.
    static let onlyPollIcon = DeveloperToolsSupport.ImageResource(name: "OnlyPollIcon", bundle: resourceBundle)

    /// The "PluralIcon" asset catalog image resource.
    static let pluralIcon = DeveloperToolsSupport.ImageResource(name: "PluralIcon", bundle: resourceBundle)

    /// The "QuestionIcon" asset catalog image resource.
    static let questionIcon = DeveloperToolsSupport.ImageResource(name: "QuestionIcon", bundle: resourceBundle)

    /// The "Search" asset catalog image resource.
    static let search = DeveloperToolsSupport.ImageResource(name: "Search", bundle: resourceBundle)

    /// The "SignIcon" asset catalog image resource.
    static let signIcon = DeveloperToolsSupport.ImageResource(name: "SignIcon", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// The "AttachImageColor" asset catalog color.
    static var attach: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .attach)
#else
        .init()
#endif
    }

    /// The "CalendarColor" asset catalog color.
    static var calendar: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .calendar)
#else
        .init()
#endif
    }

    /// The "CopyrightColor" asset catalog color.
    static var copyright: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .copyright)
#else
        .init()
#endif
    }

    /// The "EnrollButtonColor" asset catalog color.
    static var enrollButton: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .enrollButton)
#else
        .init()
#endif
    }

    /// The "MainTitleFontColor" asset catalog color.
    static var mainTitleFont: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .mainTitleFont)
#else
        .init()
#endif
    }

    /// The "OAuthLoginButtonBorderColor" asset catalog color.
    static var oAuthLoginButtonBorder: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .oAuthLoginButtonBorder)
#else
        .init()
#endif
    }

    /// The "PollContentInfoFontColor" asset catalog color.
    static var pollContentInfoFont: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pollContentInfoFont)
#else
        .init()
#endif
    }

    /// The "PollContentTitleBackgroundColor" asset catalog color.
    static var pollContentTitleBackground: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pollContentTitleBackground)
#else
        .init()
#endif
    }

    /// The "PollContentTitleFontColor" asset catalog color.
    static var pollContentTitleFont: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pollContentTitleFont)
#else
        .init()
#endif
    }

    /// The "SearchBorderColor" asset catalog color.
    static var searchBorder: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .searchBorder)
#else
        .init()
#endif
    }

    /// The "SelectedPollColor" asset catalog color.
    static var selectedPoll: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .selectedPoll)
#else
        .init()
#endif
    }

    /// The "ToolbarBackgroundColor" asset catalog color.
    static var toolbarBackground: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .toolbarBackground)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "AttachImageColor" asset catalog color.
    static var attach: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .attach)
#else
        .init()
#endif
    }

    /// The "CalendarColor" asset catalog color.
    static var calendar: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .calendar)
#else
        .init()
#endif
    }

    /// The "CopyrightColor" asset catalog color.
    static var copyright: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .copyright)
#else
        .init()
#endif
    }

    /// The "EnrollButtonColor" asset catalog color.
    static var enrollButton: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .enrollButton)
#else
        .init()
#endif
    }

    /// The "MainTitleFontColor" asset catalog color.
    static var mainTitleFont: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .mainTitleFont)
#else
        .init()
#endif
    }

    /// The "OAuthLoginButtonBorderColor" asset catalog color.
    static var oAuthLoginButtonBorder: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .oAuthLoginButtonBorder)
#else
        .init()
#endif
    }

    /// The "PollContentInfoFontColor" asset catalog color.
    static var pollContentInfoFont: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .pollContentInfoFont)
#else
        .init()
#endif
    }

    /// The "PollContentTitleBackgroundColor" asset catalog color.
    static var pollContentTitleBackground: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .pollContentTitleBackground)
#else
        .init()
#endif
    }

    /// The "PollContentTitleFontColor" asset catalog color.
    static var pollContentTitleFont: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .pollContentTitleFont)
#else
        .init()
#endif
    }

    /// The "SearchBorderColor" asset catalog color.
    static var searchBorder: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .searchBorder)
#else
        .init()
#endif
    }

    /// The "SelectedPollColor" asset catalog color.
    static var selectedPoll: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .selectedPoll)
#else
        .init()
#endif
    }

    /// The "ToolbarBackgroundColor" asset catalog color.
    static var toolbarBackground: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .toolbarBackground)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    /// The "AttachImageColor" asset catalog color.
    static var attach: SwiftUI.Color { .init(.attach) }

    /// The "CalendarColor" asset catalog color.
    static var calendar: SwiftUI.Color { .init(.calendar) }

    /// The "CopyrightColor" asset catalog color.
    static var copyright: SwiftUI.Color { .init(.copyright) }

    /// The "EnrollButtonColor" asset catalog color.
    static var enrollButton: SwiftUI.Color { .init(.enrollButton) }

    /// The "MainTitleFontColor" asset catalog color.
    static var mainTitleFont: SwiftUI.Color { .init(.mainTitleFont) }

    /// The "OAuthLoginButtonBorderColor" asset catalog color.
    static var oAuthLoginButtonBorder: SwiftUI.Color { .init(.oAuthLoginButtonBorder) }

    /// The "PollContentInfoFontColor" asset catalog color.
    static var pollContentInfoFont: SwiftUI.Color { .init(.pollContentInfoFont) }

    /// The "PollContentTitleBackgroundColor" asset catalog color.
    static var pollContentTitleBackground: SwiftUI.Color { .init(.pollContentTitleBackground) }

    /// The "PollContentTitleFontColor" asset catalog color.
    static var pollContentTitleFont: SwiftUI.Color { .init(.pollContentTitleFont) }

    /// The "SearchBorderColor" asset catalog color.
    static var searchBorder: SwiftUI.Color { .init(.searchBorder) }

    /// The "SelectedPollColor" asset catalog color.
    static var selectedPoll: SwiftUI.Color { .init(.selectedPoll) }

    /// The "ToolbarBackgroundColor" asset catalog color.
    static var toolbarBackground: SwiftUI.Color { .init(.toolbarBackground) }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "AttachImageColor" asset catalog color.
    static var attach: SwiftUI.Color { .init(.attach) }

    /// The "CalendarColor" asset catalog color.
    static var calendar: SwiftUI.Color { .init(.calendar) }

    /// The "CopyrightColor" asset catalog color.
    static var copyright: SwiftUI.Color { .init(.copyright) }

    /// The "EnrollButtonColor" asset catalog color.
    static var enrollButton: SwiftUI.Color { .init(.enrollButton) }

    /// The "MainTitleFontColor" asset catalog color.
    static var mainTitleFont: SwiftUI.Color { .init(.mainTitleFont) }

    /// The "OAuthLoginButtonBorderColor" asset catalog color.
    static var oAuthLoginButtonBorder: SwiftUI.Color { .init(.oAuthLoginButtonBorder) }

    /// The "PollContentInfoFontColor" asset catalog color.
    static var pollContentInfoFont: SwiftUI.Color { .init(.pollContentInfoFont) }

    /// The "PollContentTitleBackgroundColor" asset catalog color.
    static var pollContentTitleBackground: SwiftUI.Color { .init(.pollContentTitleBackground) }

    /// The "PollContentTitleFontColor" asset catalog color.
    static var pollContentTitleFont: SwiftUI.Color { .init(.pollContentTitleFont) }

    /// The "SearchBorderColor" asset catalog color.
    static var searchBorder: SwiftUI.Color { .init(.searchBorder) }

    /// The "SelectedPollColor" asset catalog color.
    static var selectedPoll: SwiftUI.Color { .init(.selectedPoll) }

    /// The "ToolbarBackgroundColor" asset catalog color.
    static var toolbarBackground: SwiftUI.Color { .init(.toolbarBackground) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "AnonymousIcon" asset catalog image.
    static var anonymousIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .anonymousIcon)
#else
        .init()
#endif
    }

    /// The "AppIconImage" asset catalog image.
    static var appIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .appIcon)
#else
        .init()
#endif
    }

    /// The "KakaoIcon" asset catalog image.
    static var kakaoIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .kakaoIcon)
#else
        .init()
#endif
    }

    /// The "NaverIcon" asset catalog image.
    static var naverIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .naverIcon)
#else
        .init()
#endif
    }

    /// The "OnlyPollIcon" asset catalog image.
    static var onlyPollIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .onlyPollIcon)
#else
        .init()
#endif
    }

    /// The "PluralIcon" asset catalog image.
    static var pluralIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pluralIcon)
#else
        .init()
#endif
    }

    /// The "QuestionIcon" asset catalog image.
    static var questionIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .questionIcon)
#else
        .init()
#endif
    }

    /// The "Search" asset catalog image.
    static var search: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .search)
#else
        .init()
#endif
    }

    /// The "SignIcon" asset catalog image.
    static var signIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .signIcon)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "AnonymousIcon" asset catalog image.
    static var anonymousIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .anonymousIcon)
#else
        .init()
#endif
    }

    /// The "AppIconImage" asset catalog image.
    static var appIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .appIcon)
#else
        .init()
#endif
    }

    /// The "KakaoIcon" asset catalog image.
    static var kakaoIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .kakaoIcon)
#else
        .init()
#endif
    }

    /// The "NaverIcon" asset catalog image.
    static var naverIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .naverIcon)
#else
        .init()
#endif
    }

    /// The "OnlyPollIcon" asset catalog image.
    static var onlyPollIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .onlyPollIcon)
#else
        .init()
#endif
    }

    /// The "PluralIcon" asset catalog image.
    static var pluralIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pluralIcon)
#else
        .init()
#endif
    }

    /// The "QuestionIcon" asset catalog image.
    static var questionIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .questionIcon)
#else
        .init()
#endif
    }

    /// The "Search" asset catalog image.
    static var search: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .search)
#else
        .init()
#endif
    }

    /// The "SignIcon" asset catalog image.
    static var signIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .signIcon)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif


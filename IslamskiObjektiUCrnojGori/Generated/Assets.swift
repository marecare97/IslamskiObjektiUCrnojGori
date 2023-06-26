// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
  }
  internal enum Images {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let back = ImageAsset(name: "back")
    internal static let baselineAnnouncementWhite20 = ImageAsset(name: "baseline_announcement_white_20")
    internal static let baselineArrowBackWhite24 = ImageAsset(name: "baseline_arrow_back_white_24")
    internal static let baselineCloseWhite36 = ImageAsset(name: "baseline_close_white_36")
    internal static let baselineCollectionsWhite36 = ImageAsset(name: "baseline_collections_white_36")
    internal static let baselineDirectionsWhite36 = ImageAsset(name: "baseline_directions_white_36")
    internal static let baselineGpsFixedBlack18 = ImageAsset(name: "baseline_gps_fixed_black_18")
    internal static let baselineGpsNotFixedBlack18 = ImageAsset(name: "baseline_gps_not_fixed_black_18")
    internal static let baselineSearchWhite36 = ImageAsset(name: "baseline_search_white_36")
    internal static let baselineSettingsBackupRestoreWhite24 = ImageAsset(name: "baseline_settings_backup_restore_white_24")
    internal static let baselineSettingsWhite36 = ImageAsset(name: "baseline_settings_white_36")
    internal static let baselineShareWhite36 = ImageAsset(name: "baseline_share_white_36")
    internal static let bgDetails = ImageAsset(name: "bg_details")
    internal static let defaultIcon = ImageAsset(name: "default_icon")
    internal static let drawerMenu = ImageAsset(name: "drawer_menu")
    internal static let filter = ImageAsset(name: "filter")
    internal static let filterMajorMonotone = ImageAsset(name: "filter_major_monotone")
    internal static let fond = ImageAsset(name: "fond")
    internal static let fond2 = ImageAsset(name: "fond2")
    internal static let icFilter = ImageAsset(name: "ic_filter")
    internal static let icLauncher = ImageAsset(name: "ic_launcher")
    internal static let icLocationGreen = ImageAsset(name: "ic_location_green")
    internal static let icStatusBar = ImageAsset(name: "ic_status_bar")
    internal static let iconBell = ImageAsset(name: "icon-bell")
    internal static let iconFilter = ImageAsset(name: "icon-filter")
    internal static let iconGallery = ImageAsset(name: "icon-gallery")
    internal static let icon1 = ImageAsset(name: "icon1")
    internal static let icon2 = ImageAsset(name: "icon2")
    internal static let icon3 = ImageAsset(name: "icon3")
    internal static let icon4 = ImageAsset(name: "icon4")
    internal static let institution = ImageAsset(name: "institution")
    internal static let list = ImageAsset(name: "list")
    internal static let locality = ImageAsset(name: "locality")
    internal static let map = ImageAsset(name: "map")
    internal static let masjid = ImageAsset(name: "masjid")
    internal static let moon = ImageAsset(name: "moon")
    internal static let mosque = ImageAsset(name: "mosque")
    internal static let outlineKeyboardArrowDownWhite24 = ImageAsset(name: "outline_keyboard_arrow_down_white_24")
    internal static let path = ImageAsset(name: "path")
    internal static let qiblaCompass = ImageAsset(name: "qibla_compass")
    internal static let splashBgd = ImageAsset(name: "splash_bgd")
    internal static let toolbar = ImageAsset(name: "toolbar")
    internal static let turbe = ImageAsset(name: "turbe")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

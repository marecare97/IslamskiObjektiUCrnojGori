// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum TK {
  internal enum HomePageView {
    /// Naziv objekta...
    internal static let objectName = TK.tr("sr", "homePageView.objectName", fallback: "Naziv objekta...")
    /// Objekti
    internal static let objects = TK.tr("sr", "homePageView.objects", fallback: "Objekti")
  }
  internal enum LeftSideMenu {
    /// O projektu
    internal static let about = TK.tr("sr", "leftSideMenu.about", fallback: "O projektu")
    /// Hidžeretski kalendar
    internal static let calendar = TK.tr("sr", "leftSideMenu.calendar", fallback: "Hidžeretski kalendar")
    /// Najbliža džamija za namaz
    internal static let closestObject = TK.tr("sr", "leftSideMenu.closestObject", fallback: "Najbliža džamija za namaz")
    /// Kibla
    internal static let kibla = TK.tr("sr", "leftSideMenu.kibla", fallback: "Kibla")
    /// Notifikacije
    internal static let notifications = TK.tr("sr", "leftSideMenu.notifications", fallback: "Notifikacije")
    /// sr.strings
    ///   IslamskiObjektiUCrnojGori
    /// 
    ///   Created by Nikola Matijevic on 7.3.23..
    internal static let objects = TK.tr("sr", "leftSideMenu.objects", fallback: "Objekti")
    /// Moj namaz
    internal static let sectionTitle = TK.tr("sr", "leftSideMenu.sectionTitle", fallback: "Moj namaz")
    /// Korisni linkovi
    internal static let usefulLinks = TK.tr("sr", "leftSideMenu.usefulLinks", fallback: "Korisni linkovi")
    /// Vaktija
    internal static let vaktija = TK.tr("sr", "leftSideMenu.vaktija", fallback: "Vaktija")
  }
  internal enum ObjectDetails {
    /// N. visina:
    internal static let altitude = TK.tr("sr", "objectDetails.altitude", fallback: "N. visina:")
    /// Osnovni podaci
    internal static let basicInfo = TK.tr("sr", "objectDetails.basicInfo", fallback: "Osnovni podaci")
    /// Dimenzije u osnovi:
    internal static let basis = TK.tr("sr", "objectDetails.basis", fallback: "Dimenzije u osnovi:")
    /// Godina izgradnje:
    internal static let built = TK.tr("sr", "objectDetails.built", fallback: "Godina izgradnje:")
    /// Grad:
    internal static let city = TK.tr("sr", "objectDetails.city", fallback: "Grad:")
    /// Dimenzije
    internal static let dimensions = TK.tr("sr", "objectDetails.dimensions", fallback: "Dimenzije")
    /// Geografski podaci
    internal static let geoInfo = TK.tr("sr", "objectDetails.geoInfo", fallback: "Geografski podaci")
    /// G. širina:
    internal static let latitude = TK.tr("sr", "objectDetails.latitude", fallback: "G. širina:")
    /// G. dužina:
    internal static let longitude = TK.tr("sr", "objectDetails.longitude", fallback: "G. dužina:")
    /// Medžlis:
    internal static let medzlis = TK.tr("sr", "objectDetails.medzlis", fallback: "Medžlis:")
    /// Tip objekta:
    internal static let objectType = TK.tr("sr", "objectDetails.objectType", fallback: "Tip objekta:")
  }
  internal enum ReportProblem {
    /// Vaš komentar
    internal static let comment = TK.tr("sr", "reportProblem.comment", fallback: "Vaš komentar")
    /// Pošalji
    internal static let send = TK.tr("sr", "reportProblem.send", fallback: "Pošalji")
    /// Vaša e-mail adresa
    internal static let yourEmail = TK.tr("sr", "reportProblem.yourEmail", fallback: "Vaša e-mail adresa")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension TK {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

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
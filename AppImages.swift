import UIKit

/// - Note:
/// Usage:  1)  UIImage(app: .menu)
///         2)  UIImage[.menu]

enum AppImage: String {
    case menu = "ic_menu"
    case back = "iconBack"
    case profilePlaceholder = "profile_placeholder"
    case locationPulse = "ic_location_pulse"
    case carSmall = "ic_car_small"
    case myLocation = "ic_my_location"
}

extension AppImage {
    var image: UIImage {
        return UIImage(named: rawValue)!
    }
}

extension UIImage {
    convenience init(app: AppImage) {
        self.init(named: app.rawValue)!
    }

    static subscript(app: AppImage) -> UIImage {
        return UIImage(app: app)
    }
}

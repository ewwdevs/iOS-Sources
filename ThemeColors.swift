/// - Note: Add all colours set to Assets with appropriate name
/// Usage:  Way 1: UIColor(theme: .primary)
///         Way 2: UIColor[.primary]
///
enum ThemeColor: String {
    case primary    = "themePrimary"
    case background = "themeBackground"
    case grey       = "themeGray"
}

extension UIColor {
    convenience init(theme: ThemeColor) {
        self.init(named: theme.rawValue)!
    }
    static subscript(theme: ThemeColor) -> UIColor {
        UIColor(theme: theme)
    }
}

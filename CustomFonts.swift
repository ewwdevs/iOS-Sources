import UIKit

/// - Note:
/// Step 1: Add copy font file to project
/// Step 2: Add copied font name to info.plist file
/*
 <key>UIAppFonts</key>
 <array>
     <string>JosefinSans-Bold.ttf</string>
     <string>JosefinSans-Regular.ttf</string>
     <string>JosefinSans-SemiBold.ttf</string>
 </array>
 */
/// Step 3: Print familyNames (UIFont.familyNames)
/// Step 4: find the exact font name for each weight (UIFont.fontNames(forFamilyName: "JosefinSans")
/// Step 5: add them to below enum

enum AppFont: String {
    case regular  = "JosefinSans-Regular"
    case semibold = "JosefinSans-SemiBold"
    case bold     = "JosefinSans-Bold"
}

extension UIFont {
    static func app(ofSize size: CGFloat, weight: AppFont) -> UIFont {
        UIFont(name: weight.rawValue, size: size)!
    }
}

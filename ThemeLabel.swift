import UIKit

class ThemeLabel: UILabel {
    @IBInspectable var fontSize: CGFloat = 12

    @IBInspectable var regular: Bool = false
    @IBInspectable var semibold: Bool = false
    @IBInspectable var bold: Bool = false

    @IBInspectable var white: Bool = false
    @IBInspectable var gray: Bool = false
    @IBInspectable var black: Bool = false
    @IBInspectable var blue: Bool = false
    @IBInspectable var primary: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
    }

    func applyStyle() {
        if semibold {
            font = UIFont.app(ofSize: fontSize, weight: .semibold)
        } else if bold {
            font = UIFont.app(ofSize: fontSize, weight: .bold)
        } else {
            font = UIFont.app(ofSize: fontSize, weight: .regular)
        }

        if white {
            textColor = .white
        } else if black {
            textColor = .black
        } else if gray {
            textColor = UIColor[.grey]
        }
    }
}

import UIKit

class ThemeControl: UIControl {
    
    private var didTapped: (() -> Void)?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    func setViews() {
        isUserInteractionEnabled = true
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        subview.isUserInteractionEnabled = false
    }

    func setOnClickListener(_ action: @escaping () -> Void) {
        self.didTapped = action
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        self.alpha = 0.5
        UISelectionFeedbackGenerator().selectionChanged()
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        self.alpha = 1
        UISelectionFeedbackGenerator().selectionChanged()
        self.didTapped?()
    }

    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        self.alpha = 1
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

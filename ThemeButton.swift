
import Foundation
import UIKit

class ThemePrimaryButton: UIButton {
    private var activityIndicator: UIActivityIndicatorView!
    private var originalButtonText: String?
    var shouldTriggerHaptic = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 40)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        clipToCapsule()
    }

    func setViews() {
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemBlue
        titleLabel?.font = .app(ofSize: 16, weight: .semibold)
        setNeedsDisplay()
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: isHighlighted ? 0.1 : 0.2) {
                self.transform = self.isHighlighted ? .init(scaleX: 0.8, y: 0.8) : .identity
            }
            if isHighlighted && shouldTriggerHaptic {
                shouldTriggerHaptic = false
                UISelectionFeedbackGenerator().selectionChanged()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.shouldTriggerHaptic = true
                }
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .systemBlue : .gray
        }
    }
}

// MARK: - Loader

extension ThemePrimaryButton {
    func showLoading(title: String) {
        isEnabled = false
        originalButtonText = titleLabel?.text
        setTitle(title, for: .normal)
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }
        showSpinning()
    }

    func hideLoading() {
        isEnabled = true
        setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: titleLabel!.leadingAnchor, constant: -10).isActive = true
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        activityIndicator.setCenterToViewConstraints()
    }
}

class ThemeBouncingButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: isHighlighted ? 0.1 : 0.2) {
                self.transform = self.isHighlighted ? .init(scaleX: 0.8, y: 0.8) : .identity
            }
            if isHighlighted {
                UISelectionFeedbackGenerator().selectionChanged()
            }
        }
    }
}

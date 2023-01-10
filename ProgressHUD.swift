import UIKit

class ProgressHUD: UIView {
    static var instance: ProgressHUD?

    init(title: String?) {
        super.init(frame: .zero)
        backgroundColor = .black.withAlphaComponent(0.3)

        let blurryView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurryView.layer.cornerRadius = 16
        blurryView.clipsToBounds = true
        blurryView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurryView)

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(indicator)
        if title != nil {
            let label = UILabel(frame: .zero)
            label.text = title
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            stackView.addArrangedSubview(label)
        }
        blurryView.contentView.addSubview(stackView)
        indicator.startAnimating()
        NSLayoutConstraint.activate([
            blurryView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: blurryView.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: blurryView.topAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: blurryView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: blurryView.bottomAnchor, constant: -20),

        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIViewController {
    func showProgress(title: String? = nil) {
        var contentView: UIView!
        if view.isKind(of: UITableView.self) {
            contentView = navigationController?.view ?? view
        } else {
            contentView = view
        }
        let progress = ProgressHUD(title: title)
        ProgressHUD.instance = progress
        progress.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(progress)
        NSLayoutConstraint.activate([
            progress.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            progress.topAnchor.constraint(equalTo: contentView.topAnchor),
            progress.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func hideProgress() {
        ProgressHUD.instance?.removeFromSuperview()
        ProgressHUD.instance = nil
    }
}

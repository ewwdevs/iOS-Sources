import UIKit

/// - Note:
/// Usage: let loginVC: LoginVC = AppViewController.login.getInstance()
///
enum AppViewController {
    case login
    case sideMenu
}

extension AppViewController {
    var storyboard: UIStoryboard.Storyboard {
        switch self {
        case .login:
            return .auth
        case .sideMenu:
            return .home
        }
    }

    func getInstance<T: UIViewController>() -> T {
        return getViewController()
    }

    func getViewController<T: UIViewController>() -> T {
        return UIStoryboard(storyboard: storyboard).instantiate()
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}

extension UIStoryboard {
    /// The uniform place where we state all the storyboard we have in our application

    enum Storyboard: String {
        case home = "Home"
        case auth = "Auth"

        var filename: String {
            return rawValue
        }

        var instance: UIStoryboard {
            return UIStoryboard(storyboard: self)
        }
    }

    // MARK: - Convenience Initializers

    convenience init(storyboard: Storyboard) {
        self.init(name: storyboard.filename, bundle: nil)
    }

    // MARK: - Class Functions

    class func storyboard(_ storyboard: Storyboard) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: nil)
    }

    // MARK: - View Controller Instantiation from Generics

    func instantiate<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }

        return viewController
    }
}

// usage
// let viewController: ArticleViewController = UIStoryboard(storyboard: .news).instantiate()

extension UIViewController {
    func pushViewController(_ viewController: UIViewController, _ animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func goBack() {
        if navigationController?.hasMoreThanOneViewControllers ?? false {
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.dismiss(animated: true)
        }
    }

    func bindToNavigation(isHidden: Bool = false) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: self)
        navVC.isNavigationBarHidden = isHidden
        return navVC
    }

    func closeViewController<T: UIViewController>(ofType _: T.Type) {
        if let presentedVC = presentedViewController as? T {
            presentedVC.dismiss(animated: true)
        }
    }
}

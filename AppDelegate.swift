import GoogleMaps
import GooglePlaces
import SideMenuSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LocationManager.shared.start()
        UserModel.shared.readSharedUser()
        GMSServices.provideAPIKey(WSConstants.googleApiKey)
        GMSPlacesClient.provideAPIKey(WSConstants.googleApiKey)
        setupWindow()
        return true
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        setRootView()
        window?.makeKeyAndVisible()
    }

    func setRootView() {
        if UserModel.shared.isLoggedIn() {
            setHomeScreen()
        } else {
            setLoginScreen()
        }
    }

    func setLoginScreen() {
        let loginVC: LoginVC = Router.login.getInstance()
        window?.rootViewController = loginVC
    }

    func setHomeScreen() {
        FavouriteAddressManager.shared.sync()
        let homeVC = HomeViewController()
        let sideMenuVC: SideMenuVC = Router.sideMenu.getInstance()
        let menuVC = SideMenuController(
            contentViewController: homeVC.bindToNavigation(),
            menuViewController: sideMenuVC)
        window?.rootViewController = menuVC
    }

    func logoutUser() {
        UserModel.shared.destroy()
        setLoginScreen()
    }
    
    func setupNavigationAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor[.primary]
        appearance.titleTextAttributes = [.font: UIFont.app(ofSize: 17, weight: .semibold),
                                          .foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor =  UIColor[.primary]
        UINavigationBar.appearance().isTranslucent = false
        UIBarButtonItem.appearance().tintColor = .white
    }
    
    func setupNavigationSystemAppearance() {
        let appearance = UINavigationBarAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

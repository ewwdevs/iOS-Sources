
import Foundation

enum AppEnvironmentType: String {
    case development
    case production
}

extension AppEnvironmentType {
    var hostUrl: String {
        switch self {
        case .development:
            return "http://dev-url"
        case .production:
            return "http://production-url"
        }
    }

    var socketUrl: String {
        "\(hostUrl):8080/"
    }
}

class AppEnvironment {
    static let shared = AppEnvironment()
    lazy var environment: AppEnvironmentType = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of: "Debug") != nil {
                return AppEnvironmentType.development
            }
        }
        return AppEnvironmentType.production
    }()

    static var hostUrl: String {
        AppEnvironment.shared.environment.hostUrl
    }

    static var apiUrl: String {
        "\(hostUrl)/api/customer_api"
    }

    static var socketUrl: String {
        AppEnvironment.shared.environment.socketUrl
    }
}

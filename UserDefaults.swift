
import Foundation

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool {
        self == nil
    }
}

@propertyWrapper struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T
    var storage: UserDefaults

    var wrappedValue: T {
        get {
            storage.value(forKey: key) as? T ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                storage.setValue(newValue, forKey: key)
            }
        }
    }
}

extension UserDefaultsWrapper where T: ExpressibleByNilLiteral {
    init(key: String, storage: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}

@propertyWrapper struct UserDefaultsCodableWrapper<T: Codable> {
    let key: String
    private let storage = UserDefaults.standard
    var wrappedValue: T? {
        get {
            if let data = UserDefaults.standard.value(forKey: key) as? Data {
                return try? PropertyListDecoder().decode(T.self, from: data)
            } else {
                return nil
            }
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
            } else {
                let data = try? PropertyListEncoder().encode(newValue)
                storage.set(data, forKey: key)
            }
            storage.synchronize()
        }
    }
}

enum AppDefaults {
    @UserDefaultsCodableWrapper(key: "ud_user_model")
    static var userModel: UserModel?

    @UserDefaultsCodableWrapper(key: "ud_address_array")
    static var favouriteAddresses: [FavouriteAddress]?
}

class UserModel: Codable, Convertible {
    static let shared = UserModel()

    var id: String = ""
    var xAPIKey: String = ""
    var firstName, lastName, email: String?

    func getFullName() -> String {
        [firstName, lastName]
            .compactMap { $0 }
            .filter { $0.isEmpty == false }
            .joined(separator: " ")
    }

    private init() {}

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case xAPIKey = "x-api-key"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        firstName = try? container.decode(String.self, forKey: .firstName)
        lastName = try? container.decode(String.self, forKey: .lastName)
        email = try? container.decode(String.self, forKey: .email)
        xAPIKey = try container.decode(String.self, forKey: .xAPIKey)
    }

    func resetSharedInstance(_ user: UserModel?) {
        id = user?.id ?? ""
        firstName = user?.firstName
        lastName = user?.lastName
        email = user?.email
        xAPIKey = user?.xAPIKey ?? ""
    }

    func destroy() {
        resetSharedInstance(nil)
    }
}

extension UserModel {
    func isLoggedIn() -> Bool {
        id.isNotEmpty
    }

    func saveSharedUser() {
        if UserModel.shared.xAPIKey.isEmpty {
            AppDefaults.userModel = nil
        } else {
            AppDefaults.userModel = self
        }
    }

    func readSharedUser() {
        let userModel = AppDefaults.userModel
        resetSharedInstance(userModel)
    }
}


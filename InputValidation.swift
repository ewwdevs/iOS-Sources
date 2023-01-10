import Foundation
import UIKit

typealias ValidationResult = (isValid: Bool, error: String?)

enum InputValidation {
    case email
    case password
    case mobile
    case name
    case nonEmpty
    case username
    case referralCode
}

extension InputValidation {
    var maxLimit: Int {
        switch self {
        case .mobile: return 10
        case .name: return 25
        case .password: return 15
        case .referralCode: return 30
        default: return 200
        }
    }

    var allowedCharacters: String {
        switch self {
        case .email:
            return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&'*+-/=?^_`{|}~;@."
        case .mobile:
            return "0123456789"
        default:
            return ""
        }
    }

    var pattern: String {
        switch self {
        case .email:
            return "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
        case .username:
            return "^\\w{7,18}$"
        case .password:
            return "[a-zA-Z0-9!@#$%^&*]{8,15}"
        // [a-zA-Z0-9!@#$%^&*]
        //  return "(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,15}"
        case .mobile:
            return "[0-9]{10}"
        case .name:
            return "[A-Za-z]{2,25}"
        case .nonEmpty:
            return ""
        case .referralCode:
            return "^\\w{0,20}$"
        }
    }

    func isValid(input: String, field: String) -> ValidationResult {
        switch self {
        case .email:
            return validateEmail(input: input, field: field)
        case .password:
            return validatePassword(input: input, field: field)
        case .mobile:
            return validateMobile(input: input, field: field)
        case .name:
            return validateName(input: input, field: field)
        case .nonEmpty:
            return validateNoEmpty(input: input, field: field)
        case .username:
            return validateUsername(input: input, field: field)
        case .referralCode:
            return validateRefferalCode(input: input, field: field)
        }
    }

    func isValidForPattern(input: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: input)
    }
}

// MARK: - Validation Methods

extension InputValidation {
    // MARK: - None Empty

    func validateNoEmpty(input: String, field: String) -> ValidationResult {
        if input.isEmpty {
            return (false, "\(Messages.pleaseEnter) \(field)")
        } else {
            return (true, nil)
        }
    }

    // MARK: - Name

    func validateName(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard input.count > 1 else {
            return (false, "Please enter minimum 2 characters in \(field).")
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid) \(field)")
        }
        return (true, "")
    }

    // MARK: - Email

    func validateEmail(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid) \(field)")
        }
        return (true, "")
    }

    // MARK: - Mobile

    func validateMobile(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid) \(field)")
        }
        return (true, "")
    }

    // MARK: - UserName

    func validateUsername(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard input.count >= 7 && input.count <= 18 else {
            return (false, Messages.invalidUsernameRange)
        }
        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.specialCharacterNotAllowed) \(field)")
        }
        return (true, "")
    }

    // MARK: - Password

    func validatePassword(input: String, field: String) -> ValidationResult {
        let emptyValidation = validateNoEmpty(input: input, field: field)
        guard emptyValidation.isValid else {
            return emptyValidation
        }
        guard input.count >= 8 && input.count <= 25 else {
            return (false, Messages.invalidPasswordRange)
        }

        guard isValidForPattern(input: input) else {
            return (false, "\(Messages.pleaseEnterValid) \(field)")
        }
        return (true, "")
    }

    // MARK: - Refferal code

    func validateRefferalCode(input: String, field _: String) -> ValidationResult {
        return (input.count <= 20, "")
    }
}

extension InputValidation {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        var isValid = newString.length <= maxLimit
        let characters = allowedCharacters
        if isValid && characters.isEmpty == false {
            let allowedCharacters = CharacterSet(charactersIn: characters)
            let characterSet = CharacterSet(charactersIn: string)
            isValid = allowedCharacters.isSuperset(of: characterSet)
        }
        return isValid
    }
}

enum Messages {
    static let pleaseEnter = "Please Enter"
    static let pleaseEnterValid = "Please Enter valid"
    static let specialCharacterNotAllowed = "Sorry! special characters are not allowed in"
    static let invalidUsernameRange = "Username must be between 8 and 18 characters"
    static let invalidPasswordRange = "Password must be between 8 and 25 characters"
}

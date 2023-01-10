import Kingfisher
import UIKit

enum ImagePlaceholder {
    case none
    case profile
    case custom(_ image: UIImage)

    var image: UIImage? {
        switch self {
        case .none:
            return nil
        case .profile:
            return UIImage(app: .profilePlaceholder)
        case let .custom(image):
            return image
        }
    }
}

extension UIImageView {
    func setImageWithBaseImageUrl(
        path: String,
        placeholder: ImagePlaceholder,
        isProfileImage _: Bool = false
    ) {
        let url = URL(imagePath: path)
        kf.setImage(with: url,
                    placeholder: placeholder.image,
                    options: [.transition(.fade(1))])
    }
}

extension URL {
    init?(imagePath: String?) {
        if let imagePath {
            self.init(string: "\(AppEnvironment.hostUrl)/\(imagePath)")
        } else {
            return nil
        }
    }
}

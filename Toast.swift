//
//  Toast.swift

import Foundation
import UIKit

enum MessageAlertState {

    case success, warning, failure, info

    var backgroundColor: UIColor {
        switch self {
        case .success:
            return #colorLiteral(red: 0.1958795544, green: 0.5833533554, blue: 0, alpha: 1)
        case .failure:
            return #colorLiteral(red: 0.6951127825, green: 0, blue: 0, alpha: 1)
        case .info:
            return #colorLiteral(red: 0, green: 0, blue: 0.7278106876, alpha: 1)
        case .warning:
            return #colorLiteral(red: 0.701996657, green: 0.6433976133, blue: 0.07563231699, alpha: 1)
        }
    }

    var icon: UIImage {
        switch self {
        case .success:
            return UIImage(systemName: "checkmark.circle")!
        case .failure:
            return UIImage(systemName: "multiply.circle")!
        case .info:
            return UIImage(systemName: "info.circle")!
        case .warning:
            return UIImage(systemName: "exclamationmark.circle")!
        }
    }
}

class Toast {
    
    static func show(with message: String, state: MessageAlertState) {
        guard let window = Helper.keyWindow else { return}
        
        let toastContainer = UIView(frame: CGRect())
        toastContainer.tag = 8424
        if window.viewWithTag(8424) != nil {
            return
        }
        let toastLabel = UILabel(frame: CGRect())
        let statusImage = UIImageView(frame: CGRect())
        statusImage.contentMode = .scaleAspectFit
        toastContainer.backgroundColor = state.backgroundColor
        statusImage.image = state.icon
        statusImage.layer.cornerRadius = 15
        statusImage.tintColor = .white
        statusImage.clipsToBounds = true

        toastContainer.alpha = 1.0
        toastContainer.layer.cornerRadius = 15
        toastContainer.clipsToBounds = true
        
        toastLabel.textAlignment = .left
        
        toastLabel.text = message
        toastLabel.font = UIFont.systemFont(ofSize: 17)
        toastLabel.textColor = .white
        
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(statusImage)
        toastContainer.addSubview(toastLabel)
        
        statusImage.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let i1 = NSLayoutConstraint(item: statusImage, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        statusImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        statusImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let i4 = NSLayoutConstraint(item: statusImage, attribute: .centerY, relatedBy: .equal, toItem: toastContainer, attribute: .centerY, multiplier: 1, constant: 0)
        toastContainer.addConstraints([i1, i4])
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: statusImage, attribute: .trailing, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        window.addSubview(toastContainer)
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: window, attribute: .leading, multiplier: 1, constant: 20)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: window, attribute: .trailing, multiplier: 1, constant: -20)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1, constant: 0)
        window.addConstraints([c1, c2, c3])
        
        DispatchQueue.main.async {
            c3.constant = 50
            
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.beginFromCurrentState, .curveLinear, .allowUserInteraction], animations: {
                //                toastContainer.alpha = 1.0
                window.layoutIfNeeded()
                
            }, completion: { _ in
                c3.constant = 0
                UIView.animate(withDuration: 0.1, delay: 4, options: .curveLinear, animations: {
                    //                    toastContainer.alpha = 0.0
                    window.layoutIfNeeded()
                }) { _ in
                    toastContainer.removeFromSuperview()
                }
            })
        }
    }
}

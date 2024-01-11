//
//  Alert.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation
import UIKit

// TODO: alertvc custom
class Alert {
    static func showNetworkError(){
        Alert.showAlertVC(title: "네트워크 에러", message: "잠시후 다시 시도해주세요.", cancelTitle: nil, confirmAction: nil, cancelAction: nil)
    }
    
    static func showAlertVC (title: String = "알림",
                             message: String?,
                             style: UIAlertController.Style = .alert,
                             confirmTitle: String = "확인",
                             cancelTitle: String?,
                             confirmAction: (() -> Void)?,
                             cancelAction: (() -> Void)?){
        
        
        guard let topVC = UIViewController.topMost else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let confirm = UIAlertAction(title: confirmTitle, style: .default, handler: {_ in 
            confirmAction?()
        })
        alert.addAction(confirm)
        
        if let cancelTitle = cancelTitle {
            let close = UIAlertAction(title: cancelTitle, style: .cancel, handler: {_ in 
                cancelAction?()
            })
            alert.addAction(close)
        }
        
        topVC.present(alert, animated: true)        
    }
}


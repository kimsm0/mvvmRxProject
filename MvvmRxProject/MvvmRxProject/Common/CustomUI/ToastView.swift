//
//  ToastView.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation
import SnapKit
import Then

class Toast {
    
    static func showToast(message: String, subMessage:String = "") {
        
        if let window = UIApplication.shared.windows.first {
            
            if let parentView = window.viewWithTag(12345) {
                parentView.removeFromSuperview()
            }
            
            let stackView = UIStackView().then {
                $0.backgroundColor = .black.withAlphaComponent(0.9)
                $0.axis = .vertical
                $0.tag = 12345
                $0.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                $0.isLayoutMarginsRelativeArrangement = true
                $0.insetsLayoutMarginsFromSafeArea = false
                $0.layer.cornerRadius = 4
            }
            
            window.addSubview(stackView)
            
            stackView.snp.makeConstraints {
                $0.top.equalTo(24 + 26)
                $0.leading.equalTo(20)
                $0.trailing.equalToSuperview().offset(-20)
            }
            
            
            let label = UILabel().then {
                $0.textColor = .white
                $0.text = subMessage != "" ? "\(message)\n\(subMessage)":"\(message)"
                $0.alpha = 1.0
                $0.clipsToBounds  =  true
                $0.numberOfLines = 0
                $0.textAlignment = .center
            }
            if subMessage != ""{
                let attributedString = NSMutableAttributedString(string: "\(label.text ?? "")", attributes: nil)
                let colorRange = (attributedString.string as NSString).range(of: "\(subMessage)")
                attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: colorRange)
                label.attributedText = attributedString
            }
            
            stackView.do {
                $0.addArrangedSubview(label)
            }
            
            let animater = UIViewPropertyAnimator(duration: 1.0, curve: .easeOut) {
                stackView.alpha = 0.0
            }
            
            animater.addCompletion { position in
                switch position {
                case .end:
                    stackView.removeFromSuperview()
                    break
                default:
                    break
                }
            }
            
            animater.startAnimation(afterDelay: 3)
        }
    }
}

//
//  String+Ex.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/8/24.
//

import Foundation

extension String {
    
    func getUnderlineAttr(attrText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(self)", attributes: nil)
        let underlineRange = (attributedString.string as NSString).range(of: "\(attrText)")
        attributedString.setAttributes([NSAttributedString.Key.underlineStyle: 1], range: underlineRange)
        return attributedString
    }
    
    func localized() -> String{        
        return String(localized: String.LocalizationValue(self))
    }
}

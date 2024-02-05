//
//  Regex.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2/4/24.
//

import Foundation
struct Regex {
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    static let name = "^[가-힣a-zA-Z ]*$"
    static let searchKeyword = "^[0-9가-힣a-zA-Z!@#$%^&*()-=+ ]*$"
    static let password = "^(?=.*\\d)(?=.*[!@#$%^&*()])(?=.*[a-z])(?=.*[A-Z]).{8,}$"
    static let passwordAdditional = "^[a-zA-Z0-9!@#$%^&*()]+$"
    
    static let passwordChar = "[!@#$%^&*()]"
    

    // 동일한 문자 있는지 체크 3자 이상
    static let charSome = ".*(.)\\1\\1.*"
    static let phoneRegEx = "[0-9]"
    static let specialCharExeptCheck = "[\\W!@#$%^&*()]"
    static let specialCharCheck = "[!@#$%^&*()]"
    static let english = "[A-Za-z]" // 영문
    
    static func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                guard let range = Range($0.range, in: text) else {return ""}
                return String(text[range])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}

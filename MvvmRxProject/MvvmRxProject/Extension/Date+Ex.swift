//
//  Date+Ex.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/4/24.
//

import Foundation
extension Date {
    
    func convertToString(format: String = "yyyy.MM.dd HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko")        
        return dateFormatter.string(from: self)
    }
}

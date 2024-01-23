//
//  LoginTimeInfo.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/23/24.
//

import Foundation

@dynamicCallable
struct EventGenerator {
    
    let letters = ["a", "b", "c", "d", "e"]
    
    func dynamicallyCall(withArguments args: [Int]) -> String {
        let random = Int.random(in: 0..<args[0])
        return letters[random%5]
    }
}


@dynamicMemberLookup
struct TodayRepo {
    var url: String
    var name: String
    
    subscript(dynamicMember key: String) -> String {
        switch key {
        case "repo":
            return url
        case "title":
            return "\(name): \(url)"
        default:
            return "none"
        }
    }
}

//
//  PrintLog.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/3/24.
//

import Foundation

struct PrintLog {
    static func printLog(_ log: Any?, file: String = #file, funcName: String = #function, line: Int = #line){
        let debugLog = "►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►[DEBUG LOG]\n FILE = \(file)\n FUNC = \(funcName)\n LINE = \(line)\n LOG = \(log ?? "NULL") \n TIME = \(Date())\n►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►►"
        print(debugLog)
    }
}

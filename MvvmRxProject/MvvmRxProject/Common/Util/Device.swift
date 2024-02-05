//
//  Device.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2/5/24.
//

import Foundation
import UIKit

struct Device {
    /// Device size 정보를 제공한다.
    struct Size {
        
        /// 디바이스 전체 Width
        static let width = CGFloat(UIScreen.main.bounds.width)
        /// 디바이스 전체 Height
        static let height = CGFloat(UIScreen.main.bounds.height)
        /// 디바이스 StatusBar Top Height
        static let statusBarHeight = CGFloat((UIApplication.shared.windows.filter { $0.isKeyWindow }.first)?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        /// 디바이스 NavigationBar Height
        static let navigationBarHeight = CGFloat(44)
        /// 디바이스 StatusBar Bottom Height notch에서 사용
        static let statusBottomHeight = CGFloat((UIApplication.shared.windows.filter { $0.isKeyWindow }.first)?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        /// StatusBar + NavigationBar Height
        static let topHeight = statusBarHeight + navigationBarHeight
        /// 디바이스에서 View Height만 계산한 결과
        static let viewHeight = height - topHeight - statusBottomHeight
    }
}

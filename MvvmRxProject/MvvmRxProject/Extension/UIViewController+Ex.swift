//
//  UIViewController+Ex.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation
import UIKit

extension UIViewController {

    private class var sharedApplication: UIApplication? {
      let selector = NSSelectorFromString("sharedApplication")
      return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
    }

    /// Returns the current application's top most view controller.
    class var topMost: UIViewController? {
      guard let currentWindows = self.sharedApplication?.windows else { return nil }
      var rootViewController: UIViewController?
      for window in currentWindows {
        if let windowRootViewController = window.rootViewController, window.isKeyWindow {
          rootViewController = windowRootViewController
          break
        }
      }

      return rootViewController
    }
}

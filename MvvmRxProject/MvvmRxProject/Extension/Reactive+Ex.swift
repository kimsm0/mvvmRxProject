//
//  Reactive+Ex.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2/4/24.
//

import UIKit
import RxSwift
import RxCocoa


extension Reactive where Base : UITextField {
    var beginEditing : ControlEvent<Void> {
        return controlEvent(.editingDidBegin)
    }
    var endEditing : ControlEvent<Void> {
        return controlEvent(.editingDidEnd)
    }
}

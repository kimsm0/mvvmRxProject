//
//  CustomTextField.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class CustomTextField: UITextField {
    
    //.editingChanged 이벤트 + 최초 초기화 1회 + 포커싱 + 언포커싱 : 모두 이벤트 방출 -> 값이 변경될 때만 방출되도록 커스텀 
    public var changedText: ControlProperty<String?> {
            return self.rx.controlProperty(editingEvents: [.editingChanged, .valueChanged], getter: { textField in
                textField.text
            }, setter: { textField, value in
                if textField.text != value {
                    textField.text = value
                }
            })
        }

    public var isNowEditing: ControlProperty<Bool> {
        return self.rx.controlProperty(editingEvents: [.editingChanged, .valueChanged], getter: { textField in
            return true
        }, setter: { textField, value in
            
        })
    }
}

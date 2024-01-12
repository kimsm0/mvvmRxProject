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
             
    var curText = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    public var finishedText: ControlProperty<String?> {
            return self.rx.controlProperty(editingEvents: [.editingDidEndOnExit, .editingDidEnd], getter: { textField in
                textField.text
            }, setter: { textField, value in
                if textField.text != value {
                    textField.text = value
                }
            })
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error")
    }

    func bind(){
        self.rx.text
            .orEmpty            
            .distinctUntilChanged()
            .bind(to: curText)
            .disposed(by: disposeBag)        
    }
    

}

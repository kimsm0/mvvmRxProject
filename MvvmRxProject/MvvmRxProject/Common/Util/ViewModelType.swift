//
//  ViewModelType.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/3/24.
//

import Foundation
import RxSwift

//뷰모델 클래스에서 사용하는 프로토콜
//Input으로 트리거를 전달 받고, Output으로 데이터를 방출
protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

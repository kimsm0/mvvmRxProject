//
//  StaticObserver.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2/5/24.
//

import Foundation
import RxSwift
import RxCocoa


class StaticObserver{
    static var tabIndexObserver: PublishRelay<Int> = PublishRelay<Int>()
}

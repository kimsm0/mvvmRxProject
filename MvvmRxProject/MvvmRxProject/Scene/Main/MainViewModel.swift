//
//  MainViewModel.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2024/01/02.
//

import Foundation
import RxCocoa
import RxSwift


class MainViewModel: ViewModelType {
    //MARK: properties
    private let model = MainModel()
    typealias SectionTypealias = (type: SearchUserSectionType, items: [SearchUserSectionItem], needToAppend: Bool)

    private var sections = PublishRelay<SectionTypealias>()
    
    private var errorMessage = PublishRelay<String>()
    var disposeBag = DisposeBag()
    private var totalCount: Int = 0
    private var curPage: Int = 1
    private var curSearchQuery = ""
}

extension MainViewModel {
    
    //MARK: input
    struct Input {
        let searchTrigger: Observable<String>
        let willDisplayCell: Observable<IndexPath>
    }
    
    //MARK: output
    struct Output {
        let sections: Observable<SectionTypealias>
        let errorMessage: Observable<String>
    }
    
    //MARK: transform
    
    func transform(input: Input) -> Output {
        
        input.searchTrigger
            .subscribe(onNext: { [weak self] query in
                guard let weakSelf = self else { return }
                if query.isEmpty {
                    let result: SectionTypealias = (type: SearchUserSectionType.userList, items: [], needToAppend: false)
                    weakSelf.sections.accept(result)
                }else{
                    weakSelf.reqUserList(query: query)
                }
            })
            .disposed(by: disposeBag)
        
        input.willDisplayCell
            .filter { $0.row + 1 > (30 * self.curPage) - 2  }
            .subscribe(onNext: { [weak self] indexPath in
                guard let weakSelf = self else { return }
                if weakSelf.curPage * 30 < weakSelf.totalCount {
                    weakSelf.curPage += 1
                    weakSelf.reqUserList(query: weakSelf.curSearchQuery)
                }
            })
            .disposed(by: disposeBag)
             
                
        return Output(sections: sections.asObservable(),
                      errorMessage: errorMessage.asObservable())
    }
}

extension MainViewModel{
                
    func reqUserList(query: String){
        PrintLog.printLog("\(query), \(curPage)")
        
        self.model.reqUserList(query: query, page: curPage)
            .map{ self.totalCount = $0.total_count
                return $0
            }.map(\.items)
            .subscribe { userList in
                if userList.isEmpty {
                    let result: SectionTypealias = (type: SearchUserSectionType.empty, items: [Empty(searchTest: query)], needToAppend: false)
                    self.sections.accept(result)
                }else{
                    let result: SectionTypealias = (type: SearchUserSectionType.userList, items: userList, needToAppend: self.curPage > 1)
                    self.sections.accept(result)
                }
            }.disposed(by: disposeBag)
    }
}

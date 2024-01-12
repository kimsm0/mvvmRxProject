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

    private var sections: BehaviorRelay<SectionTypealias> = BehaviorRelay(value: (type: SearchUserSectionType.empty, items: [], needToAppend: false))
    
    private var errorMessage = PublishRelay<String>()
    var disposeBag = DisposeBag()
    private var totalCount: Int = 0
    private var curPage: Int = 1
    private var curSearchQuery = ""
}

extension MainViewModel {
    
    //MARK: input
    struct Input {
        let initTrigger: Observable<Void>
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
        input.initTrigger
            .subscribe(onNext: {
                let result: SectionTypealias = (type: SearchUserSectionType.empty, items: [Empty()], needToAppend: false)
                self.sections.accept(result)
            })
            .disposed(by: disposeBag)
        
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
        
        model.reqUserList(query: query, page: curPage) { error, userData in
            self.curSearchQuery = query
            
            if let error = error {
                PrintLog.printLog(error.localizedDescription)
                self.errorMessage.accept("에러가 발생했습니다. 잠시후 다시 시도해주세요.")
            }else if let userData = userData, !userData.items.isEmpty {
                let result: SectionTypealias = (type: SearchUserSectionType.userList, items: userData.items, needToAppend: self.curPage > 1)
                self.totalCount = userData.total_count
                self.sections.accept(result)
            }else{
                let result: SectionTypealias = (type: SearchUserSectionType.empty, items: [Empty(searchTest: query)], needToAppend: false)
                self.sections.accept(result)
            }
        }
    }
}

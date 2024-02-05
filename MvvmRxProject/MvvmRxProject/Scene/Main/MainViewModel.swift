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
    
    typealias SectionsItemTypealias = (type: SearchUserSectionType, items: [SearchUserSectionItem])
    typealias SectionsTypealias = (item: [SectionsItemTypealias], isNew: Bool, needToDelete: Bool, needToAppend: Bool)
    
    private var sections = BehaviorRelay(value: SectionsTypealias(item:[], isNew: false, needToDelete: false, needToAppend: false))
    
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
        let sections: Observable<SectionsTypealias>
        let errorMessage: Observable<String>
    }
    
    //MARK: transform
    
    func transform(input: Input) -> Output {
        
        input.searchTrigger
            .subscribe(onNext: { [weak self] query in
                guard let weakSelf = self else { return }
                var newSections = [SectionsItemTypealias]()
                
                if query.isEmpty {
                    newSections.append((type: .empty, items: [Empty(searchText: query)]))
                    let result = SectionsTypealias(item: newSections, isNew: true, needToDelete: false, needToAppend: false)
                    weakSelf.sections.accept(result)
                }else{
                    weakSelf.reqUserList(query: query, loadMore: false)
                }
            })
            .disposed(by: disposeBag)
        
        input.willDisplayCell
            .filter { $0.row + 1 > (30 * self.curPage) - 2  }
            .subscribe(onNext: { [weak self] indexPath in
                guard let weakSelf = self else { return }
                if weakSelf.curPage * 30 < weakSelf.totalCount {
                    weakSelf.curPage += 1
                    weakSelf.reqUserList(query: weakSelf.curSearchQuery, loadMore: true)
                }
            })
            .disposed(by: disposeBag)
             
                
        return Output(sections: sections.asObservable(),
                      errorMessage: errorMessage.asObservable())
    }
}

extension MainViewModel{
                
    func reqUserList(query: String, loadMore: Bool){
        printLog("\(query), \(curPage)")
        self.curSearchQuery = query
        self.model.reqUserList(query: query, page: curPage)
            .map{
                self.totalCount = $0.total_count
                return $0.items
            }.subscribe(onNext: {[weak self] (userList: [User]) in
                guard let weakSelf = self else { return }
                if loadMore {
                    let sectionTypealias = weakSelf.sections.value
                    var preList = sectionTypealias.item.first(where: { $0.0 == .userList })?.items
                    
                    if userList.count > 0 {
                        if preList != nil {
                            preList!.append(contentsOf: userList)
                        }else{
                            preList = userList
                        }
                        let result = SectionsTypealias(item: [(type:.userList, items: preList!)], isNew: false, needToDelete: false, needToAppend: false)
                        weakSelf.sections.accept(result)
                    }
                }else {
                    var newSections = [SectionsItemTypealias]()
                    
                    var recentKeywords = [RecentKeyword]()
                    if let keywords = LocalStorage.recentSearchKeyword, keywords.count > 0  {
                        let sortedDitionary = keywords.sorted { $0.1 > $1.1 }
                        let _ = sortedDitionary.map {
                            recentKeywords.append(RecentKeyword(keyword: $0.key))
                        }
                        newSections.append((type: .recentKeyword, items: recentKeywords))
                    }
                    
                    if userList.isEmpty {
                        newSections.append((type: .empty, items: [Empty(searchText: query)]))
                    }else{
                        newSections.append((type: .userList, items: userList))
                    }
                    let result = SectionsTypealias(item: newSections, isNew: true, needToDelete: false, needToAppend: false)
                    weakSelf.sections.accept(result)
                }
                
                
            }).disposed(by: disposeBag)
    }
    
    func saveRecentKeyword(keyword: String) {
        var recentSearchKeyword: [String: String] = LocalStorage.recentSearchKeyword ?? [:]
        recentSearchKeyword[keyword] = Date().convertToString(formatType: .defaultFullWithTZType)
        LocalStorage.recentSearchKeyword = recentSearchKeyword
    }
}

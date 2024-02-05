//
//  MainModel.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2024/01/02.
//

import Foundation
import Moya
import RxSwift

class MainModel {
    let provider = MoyaProvider<MainAPI>()        
    
    func reqUserList(query: String, page: Int) -> Observable<MainUserData>{
        provider.rx.request(.userList(param: ["q": query, "per_page": 30, "page": page]))
            .filterSuccessfulStatusCodes()
            .map( MainUserData.self )
            .asObservable()
            .do(onError: {
                printLog($0.localizedDescription)
                Alert.showNetworkError()
            })
    }
}

class MainUserData: SearchUserSectionItem, Codable {
    var total_count: Int
    var incomplete_results: Bool
    var items: [User]
    
    init(total_count: Int, incomplete_results: Bool, items: [User] ) {
        self.total_count = total_count
        self.incomplete_results = incomplete_results
        self.items = items
    }
}

class User: SearchUserSectionItem, Codable {
    var login: String
    var id: Int
    var node_id: String
    var avatar_url: String
    var gravatar_id: String
    var url: String
    var followers_url: String
    var subscriptions_url: String
    var organizations_url: String
    var repos_url: String
    var received_events_url: String
    var type: String
    var score: Int
    var following_url: String
    var gists_url: String
    var starred_url: String
    var events_url: String
    var site_admin: Bool
    var html_url: String
        
}

class Empty: SearchUserSectionItem{
    var searchText: String
    
    init(searchText: String) {
        self.searchText = searchText
    }
}

class RecentKeyword: SearchUserSectionItem{
    var keyword: String
    
    init(keyword: String) {
        self.keyword = keyword
    }
}

// 검색화면 섹션 타입
public enum SearchUserSectionType: Int, CaseIterable {
    case recentKeyword
    case userList
    case empty
}

class SearchUserSectionItem: Hashable {
    let uuid = UUID()
    
    static func == (lhs: SearchUserSectionItem, rhs: SearchUserSectionItem) -> Bool {
        return lhs.uuid == rhs.uuid
    }
                
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

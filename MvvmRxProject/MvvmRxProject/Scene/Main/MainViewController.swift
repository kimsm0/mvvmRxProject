//
//  MainViewController.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2024/01/02.
//

import Foundation
import UIKit
import Then
import RxCocoa
import RxSwift
import RxDataSources

class MainViewController: CommonViewController {
    private let viewModel = MainViewModel()
    
    private let searchTrigger = PublishRelay<(String)>()
    private let willDisplayCell = PublishRelay<IndexPath>()
    
    private lazy var input = MainViewModel.Input(searchTrigger: searchTrigger.asObservable(),
                                         willDisplayCell: willDisplayCell.asObservable())
    private lazy var output = viewModel.transform(input: input)
    
    private var dataSource: UICollectionViewDiffableDataSource<SearchUserSectionType, SearchUserSectionItem>!
    
    private lazy var searchView = SearchView()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: generateLayout())
        cv.backgroundColor = .white
        cv.keyboardDismissMode = .onDrag
        cv.showsVerticalScrollIndicator = false
        cv.register(MainUserCell.self, forCellWithReuseIdentifier: String(describing: MainUserCell.self))
        cv.register(MainUserEmptyCell.self, forCellWithReuseIdentifier: String(describing: MainUserEmptyCell.self))
        return cv
    }()
    
    private let headerKind = "headerKind"
    private let recentKeywordHeader = "recentKeywordHeader"
    private let disposeBag = DisposeBag()
    
    private let guideLabel = UILabel().then{
        $0.text = "\("search_guide1".localized())\n\("search_guide2".localized())"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .black         
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layout()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
    }
    
    func bind() {
        searchView.curText
            .compactMap({ $0 })
            .bind(to: searchTrigger)
            .disposed(by: disposeBag)
        
        searchView.searchText
            .subscribe(onNext: { txt in
                if let txt = txt {
                    self.viewModel.saveRecentKeyword(keyword: txt)
                }else{
                    Toast.showToast(message: "search_validation_message".localized())
                }
            }).disposed(by: disposeBag)
       
        output.errorMessage
            .subscribe { errMsg in
                Toast.showToast(message: errMsg)
            }.disposed(by: disposeBag)
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<MainHeaderView>(elementKind: headerKind) {[weak self]
            (supplementaryView, string, indexPath) in
            guard let weakSelf = self else { return }
            supplementaryView.myRepoButton.button.rx.tap
                    .subscribe(onNext: {
                        let myPage = MypageViewController()
                        weakSelf.navigationController?.pushViewController(myPage, animated: true)
                    }).disposed(by: weakSelf.disposeBag)
            supplementaryView.config()
        }
        
        ///section header: 최근검색어 타이틀 영역
        let recentKeywordHeader = UICollectionView.SupplementaryRegistration<SearchHeaderView>(elementKind: recentKeywordHeader) {
            (supplementaryView, string, indexPath) in            
        }
        
        let userCellRegistration = UICollectionView.CellRegistration<MainUserCell, User> {
            (cell,indexPath,itemIdentifier) in
            cell.config(user: itemIdentifier)
        }
        
        let emptyCellRegistration = UICollectionView.CellRegistration<MainUserEmptyCell, Empty> {
            (cell,indexPath,itemIdentifier) in
            cell.config(searchText: itemIdentifier.searchText)
        }
        let recentKeywordCellRegistration = UICollectionView.CellRegistration<MainRecentKeywordCell, RecentKeyword> {
            (cell,indexPath,itemIdentifier) in
            cell.config(keyword: itemIdentifier.keyword)
        }
        
        
        dataSource = UICollectionViewDiffableDataSource<SearchUserSectionType, SearchUserSectionItem>(collectionView: collectionView) {[weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SearchUserSectionItem) -> UICollectionViewCell? in
            guard let weakSelf = self else { return UICollectionViewCell() }            
            
            let curSection = weakSelf.getSectionType(section: indexPath.section)
            
            if curSection == .userList {
                return collectionView.dequeueConfiguredReusableCell(using: userCellRegistration, for: indexPath, item: (identifier as! User))
                
            }else if curSection == .empty {
                return collectionView.dequeueConfiguredReusableCell(using: emptyCellRegistration, for: indexPath, item: (identifier as! Empty))
            }else if curSection == .recentKeyword {
                return collectionView.dequeueConfiguredReusableCell(using: recentKeywordCellRegistration, for: indexPath, item: (identifier as! RecentKeyword))
            }
            return UICollectionViewCell()
        }
        
        dataSource.supplementaryViewProvider = {[weak self] (view, kind, index) in
            guard let weakSelf = self else { return nil }
            if kind == weakSelf.headerKind {
                return weakSelf.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
            }else if kind == weakSelf.recentKeywordHeader {
                return weakSelf.collectionView.dequeueConfiguredReusableSupplementary(using: recentKeywordHeader, for: index)
            }
            return nil
        }
        
        ///데이터 전체 reload
        output.sections.subscribe(onNext: { [weak self] sectionsTypealias in
            guard let weakSelf = self else { return }
            var snapshot = weakSelf.dataSource.snapshot()
            var animatingDifferences = false
            if sectionsTypealias.isNew {
                snapshot.deleteAllItems()
                let _ = sectionsTypealias.item.enumerated().map{
                    snapshot.appendSections([$0.element.type])
                    snapshot.appendItems($0.element.items, toSection: $0.element.type)
                }
                animatingDifferences = true
            }else { ///부분 데이터 reload
                if let item = sectionsTypealias.item.first {
                    if sectionsTypealias.needToAppend {
                        snapshot.appendItems(item.items, toSection: item.type)
                    }else if sectionsTypealias.needToDelete {
                        snapshot.deleteSections([item.type])
                    }else {
                        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: item.type))
                        snapshot.appendItems(item.items, toSection: item.type)
                    }
                }
            }
            weakSelf.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
            weakSelf.guideLabel.isHidden = true
        }).disposed(by: disposeBag)
              
        
        collectionView.rx.itemSelected
            .subscribe(onNext:{ [weak self] indexPath in
                guard let weakSelf = self else { return }
                weakSelf.searchView.closeKeyboard()
                let type = weakSelf.getSectionType(section: indexPath.section)
                
                let snapshot = weakSelf.dataSource.snapshot()
                let items = snapshot.itemIdentifiers(inSection: type)
                if let user = items[indexPath.row] as? User {
                    WKWebViewController.showWebView(urlString: user.html_url)
                }
            }).disposed(by: disposeBag)
        
        
        collectionView.rx.willDisplayCell
            .map({ (cell, indexPath) in
                return indexPath
            })
            .bind(to: willDisplayCell)
            .disposed(by: disposeBag)
                
        output.errorMessage.subscribe { msg in
            Alert.showAlertVC(title:"error_message_title".localized() ,message: "error_message".localized(), cancelTitle: nil, confirmAction: nil, cancelAction: nil)
        }.disposed(by: disposeBag)
    }
}

// MARK: Layout
extension MainViewController {
    @inlinable
    func layout(){
        self.view.addSubview(searchView)
        self.view.addSubview(collectionView)
        self.view.addSubview(guideLabel)
        
        searchView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        guideLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(searchView.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(searchView.snp.bottom).offset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    func getSectionType(section: Int) -> SearchUserSectionType {
        let snapshot = self.dataSource.snapshot()
        let sections = snapshot.sectionIdentifiers
        let curSection = sections[section]
        return curSection
    }
    
    func generateLayout () -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let weakSelf = self else { return nil }
            let section = weakSelf.getSectionType(section: sectionIndex)
            
            if section == .userList{
                return weakSelf.getUserListSectionLayout()
            }else if section == .empty {
                return weakSelf.getEmptySectionLayout()
            }else if section == .recentKeyword {
                return weakSelf.getRecentSearchSectionLayout()
            }else {
                return weakSelf.getEmptySectionLayout()
            }
        }
        return layout
    }
        
    
    func getUserListSectionLayout() -> NSCollectionLayoutSection {
                
        let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0)
           
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
           widthDimension: .fractionalWidth(1.0),
           heightDimension: .absolute(68))
       
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
           layoutSize: headerSize,
           elementKind: headerKind,
           alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [sectionHeader]
                       
        return section
    }
    
    func getEmptySectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
           
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                       
        return section
    }
    
    func getRecentSearchSectionLayout() -> NSCollectionLayoutSection {
        let widthDimension = NSCollectionLayoutDimension.estimated(0)
        
        let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
           
        let groupSize = NSCollectionLayoutSize(widthDimension: widthDimension, heightDimension: .absolute(32))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 12)
                
        let headerSize = NSCollectionLayoutSize(
           widthDimension: .fractionalWidth(1.0),
           heightDimension: .absolute(40))
       
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
           layoutSize: headerSize,
           elementKind: recentKeywordHeader,
           alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}

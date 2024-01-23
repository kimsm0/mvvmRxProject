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
    let viewModel = MainViewModel()
    
    let searchTrigger = PublishRelay<(String)>()
    let willDisplayCell = PublishRelay<IndexPath>()
    
    lazy var input = MainViewModel.Input(searchTrigger: searchTrigger.asObservable(),
                                         willDisplayCell: willDisplayCell.asObservable())
    lazy var output = viewModel.transform(input: input)
    
    var dataSource: UICollectionViewDiffableDataSource<SearchUserSectionType, SearchUserSectionItem>!
    
    lazy var searchView = SearchView()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: generateLayout())
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.register(MainUserCell.self, forCellWithReuseIdentifier: String(describing: MainUserCell.self))
        cv.register(MainUserEmptyCell.self, forCellWithReuseIdentifier: String(describing: MainUserEmptyCell.self))
        return cv
    }()
    
    let headerKind = "headerKind"
    let disposeBag = DisposeBag()
    
    let guideLabel = UILabel().then{
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
            .filter({ ($0 ?? "").isEmpty })
            .subscribe { txt in
                Toast.showToast(message: "search_validation_message".localized())
            }.disposed(by: disposeBag)
            
        
        output.errorMessage
            .subscribe { errMsg in
                Toast.showToast(message: errMsg)
            }.disposed(by: disposeBag)
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<MainHeaderView>(elementKind: headerKind) {
            (supplementaryView, string, indexPath) in
            supplementaryView.config()
        }
        
        let userCellRegistration = UICollectionView.CellRegistration<MainUserCell, User> {
            (cell,indexPath,itemIdentifier) in
            cell.config(user: itemIdentifier)
        }
        
        let emptyCellRegistration = UICollectionView.CellRegistration<MainUserEmptyCell, Empty> {
            (cell,indexPath,itemIdentifier) in
            cell.config(searchText: itemIdentifier.searchTest)
        }
        
        
        dataSource = UICollectionViewDiffableDataSource<SearchUserSectionType, SearchUserSectionItem>(collectionView: collectionView) {[weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SearchUserSectionItem) -> UICollectionViewCell? in
            guard let weakSelf = self else { return UICollectionViewCell() }            
            
            let curSection = weakSelf.getSectionType(section: indexPath.section)
            
            if curSection == .userList {
                return collectionView.dequeueConfiguredReusableCell(using: userCellRegistration, for: indexPath, item: (identifier as! User))
                
            }else if curSection == .empty {
                return collectionView.dequeueConfiguredReusableCell(using: emptyCellRegistration, for: indexPath, item: (identifier as! Empty))
            }
            return UICollectionViewCell()
        }
        
        dataSource.supplementaryViewProvider = {[weak self] (view, kind, index) in
            guard let weakSelf = self else { return nil }
            if kind == weakSelf.headerKind {
                return weakSelf.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
            }
            return nil
        }
        
        ///데이터 전체 reload
        output.sections.subscribe(onNext: { [weak self] section in
            guard let weakSelf = self else { return }
            var snapshot = weakSelf.dataSource.snapshot()
            
            if section.needToAppend {
                snapshot.appendItems(section.items, toSection: section.type)
            }else{
                snapshot.deleteAllItems()
                snapshot.appendSections([section.type])
                snapshot.appendItems(section.items, toSection: section.type)                
            }
            
            weakSelf.dataSource.apply(snapshot, animatingDifferences: true)
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
        
        collectionView.rx
            .didScroll
            .subscribe { _ in
                self.searchView.closeKeyboard()
            }.disposed(by: disposeBag)
                
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
        
        let window = UIApplication.shared.windows.first
        guard let bottom = window?.safeAreaInsets.bottom else { return }
        guard let top = window?.safeAreaInsets.top else { return }
        
        
        searchView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(top + 16)
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
            $0.bottom.equalToSuperview().offset(-bottom)
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
            }else {
                return weakSelf.getEmptySectionLayout()
            }
        }
        return layout
    }
        
    
    func getUserListSectionLayout() -> NSCollectionLayoutSection {
                
        let item = NSCollectionLayoutItem(layoutSize:  NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(56)))
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
}

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
    
    let searchTrigger = PublishRelay<(String?)>()
    let willDisplayCell = PublishRelay<IndexPath>()
    let viewDidLoadTrigger = PublishRelay<Void>()
    
    lazy var input = MainViewModel.Input(initTrigger: viewDidLoadTrigger.asObservable(),
                                         searchTrigger: searchTrigger.asObservable(),
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
    
    private var isInit = true
    private let gesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layout()
        self.bind()
        self.viewDidLoadTrigger.accept(Void())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
    }
    
    func bind() {
        
        searchView.doneHandler = { [weak self] text in
            guard let weakSelf = self else { return }
            if text.isEmpty {
                Toast.showToast(message: "검색어를 다시 확인해주세요.")
            }else{
                weakSelf.searchTrigger.accept(text)
            }
            weakSelf.collectionView.removeGestureRecognizer(weakSelf.gesture)
        }
        
        searchView.curText
            .bind(to: searchTrigger)
            .disposed(by: disposeBag)
        
//        searchView.editingHandler = { [weak self] text in
//            guard let weakSelf = self else { return }
//            weakSelf.searchTrigger.accept("")
//            weakSelf.collectionView.addGestureRecognizer(weakSelf.gesture)
//        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<MainHeaderView>(elementKind: headerKind) {
            (supplementaryView, string, indexPath) in
            supplementaryView.config()
        }
        
        dataSource = UICollectionViewDiffableDataSource<SearchUserSectionType, SearchUserSectionItem>(collectionView: collectionView) {[weak self]
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: SearchUserSectionItem) -> UICollectionViewCell? in
            guard let weakSelf = self else { return UICollectionViewCell() }
            let curSection = weakSelf.getSectionType(section: indexPath.section)

            if curSection == .empty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainUserEmptyCell.self), for: indexPath) as! MainUserEmptyCell                
                cell.config(searchText: weakSelf.searchView.getText(), isInit: weakSelf.isInit)
                if weakSelf.isInit {
                    weakSelf.isInit = false
                }
                return cell
            }else{
                if let user = identifier as? User {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainUserCell.self), for: indexPath) as! MainUserCell
                    cell.config(user: user)
                    return cell
                }
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
        }).disposed(by: disposeBag)
              
        collectionView.rx.itemSelected
            .subscribe(onNext:{ [weak self] indexPath in
                guard let weakSelf = self else { return }
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
      
        gesture.rx.event.bind {[weak self]_ in
            guard let weakSelf = self else { return }
            weakSelf.collectionView.removeGestureRecognizer(weakSelf.gesture)
            weakSelf.searchView.closeKeyboard()
        }.disposed(by: disposeBag)
        
                
        output.errorMessage.subscribe { msg in
            Alert.showAlertVC(message: "에러", cancelTitle: nil, confirmAction: nil, cancelAction: nil)
        }.disposed(by: disposeBag)
    }
}

// MARK: Layout
extension MainViewController {
    
    func layout(){
        self.view.addSubview(searchView)
        self.view.addSubview(collectionView)
        
        let window = UIApplication.shared.windows.first
        guard let bottom = window?.safeAreaInsets.bottom else { return }
        guard let top = window?.safeAreaInsets.top else { return }
        
        
        searchView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(top + 16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
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

//
//  CommonViewController.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 1/2/24.
//

import Foundation
import UIKit
import RxAppState

class CommonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        self.customNaviBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func attribute(){
        self.view.backgroundColor = .white
    }
    
    func customNaviBar(){        
        let backImage = UIImage(systemName: "arrowshape.left.circle")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func pressedBackButton(){
        self.navigationController?.popViewController(animated: true)
    }
}

/**
 @class CustomTabBarController
 @date 2/4/24
 @writer kimsoomin
 @brief SceneDelegate window에 연결한 rootviewcontroller.
 - 깃헙 로그인 화면 LoginViewController와 이메일 로그인 화면 NewLoginViewController를 child 로 연결.
 @update history
 -
 */
import Foundation
import UIKit
import RxSwift
import RxCocoa

struct TabBar {
    var onImageName: String
    var offImageName: String
    var title: String
    var index: Int
}

class CustomTabBarViewController: UITabBarController {
            
    //MARK: properties
    let loginViewController = LoginViewController()
    let emailLoginViewController = NewLoginViewController()
        
    var tabBars: [TabBar] = []
    var curTabBar: TabBar {
        get{
            return tabBars[selectedIndex]
        }
    }
    
    //MARK: life cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        let bottom = UIApplication.shared.getSafeAreaBottom()
        tabBar.backgroundColor = .clear
        tabBar.frame.size.height = ((bottom) > 0) ? bottom + 68 : 68
        tabBar.frame.origin.x = view.bounds.width / 2 - tabBar.frame.width / 2
        tabBar.frame.origin.y = ((bottom) > 0) ? view.frame.height - (bottom + 68) : view.frame.height - 68
    }
    
    func attribute(){
        self.setValue(CustomizedTabBar(), forKey: "tabBar")
        let loginNavi = UINavigationController(rootViewController: loginViewController)
        loginNavi.navigationBar.prefersLargeTitles = true
        
        
        loginNavi.tabBarItem.image = UIImage(systemName: "lock.icloud")
        loginNavi.tabBarItem.selectedImage = UIImage(systemName: "lock.icloud.fill")
        loginNavi.tabBarItem.title = "Github Login"
        loginNavi.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
                        
        
        let loginNavi2 = UINavigationController(rootViewController: emailLoginViewController)
        loginNavi2.navigationBar.prefersLargeTitles = true
        loginNavi2.tabBarItem.image = UIImage(systemName: "lock")
        loginNavi2.tabBarItem.selectedImage = UIImage(systemName: "lock.fill")
        loginNavi2.tabBarItem.title = "Github Login"
        
        self.setViewControllers([loginNavi, loginNavi2], animated: false)
    }
        
    func layout(){
        tabBar.itemPositioning = .centered
        tabBar.itemWidth = Device.Size.width / 3
        tabBar.itemSpacing = 0.1
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor(red:0.0/255.0, green:0.0/255.0, blue:0.0/255.0, alpha:0.05).cgColor
        tabBar.clipsToBounds = true
    }
}



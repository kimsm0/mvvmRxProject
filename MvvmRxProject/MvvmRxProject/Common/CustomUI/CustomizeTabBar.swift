//
//  UITabBar+Ex.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2/5/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CustomizedTabBar: UIView {
    private var shapeLayer: CALayer?
    
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer() //CAShapeLayer 다각형/path 등을 그리기 위한 용도
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.fillColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = 1.0

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    func createPath() -> CGPath {

        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough

        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))

        // complete the rect
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath
    }

    func createPathCircle() -> CGPath {

        let radius: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
        
    func addTabItem(tabbar: TabBar){
        let tabWidth = Device.Size.width / 2
        let rect = CGRect(x: (CGFloat(tabbar.index) * (tabWidth)), y: 0, width: tabWidth, height: 68)
        let tabItemView = CustomTabItemView(frame: rect, tabbar: tabbar)
        self.addSubview(tabItemView)        
    }
}


class CustomTabItemView: UIView {
    
    var iconImageView = UIImageView()
    var titleLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    var button = UIButton()
    var tabbar: TabBar
    
    let disposeBag = DisposeBag()
    
    init(frame: CGRect, tabbar: TabBar){
        self.tabbar = tabbar
        super.init(frame: frame)
        self.layout()
        self.attribute(isOn: false)
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout(){
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(button)
        
        iconImageView.snp.makeConstraints{
            $0.width.height.equalTo(30)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(15)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(iconImageView.snp.bottom).offset(4)
            $0.height.equalTo(12)
            $0.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints{
            $0.leading.top.bottom.trailing.equalToSuperview()
        }
        
        titleLabel.text = tabbar.title
    }
    
    func attribute(isOn: Bool){
        if isOn {
            iconImageView.image = UIImage(systemName: tabbar.onImageName)
        }else{
            iconImageView.image = UIImage(systemName: tabbar.offImageName)
        }
    }
    
    func bind(){
        button.rx.tap
            .subscribe({[weak self] _ in
                guard let weakSelf = self else { return }
                StaticObserver.tabIndexObserver.accept(weakSelf.tabbar.index)
            }).disposed(by: disposeBag)
        
        StaticObserver.tabIndexObserver
            .subscribe(onNext: {[weak self] selectedIndex in
            guard let weakSelf = self else { return }
            weakSelf.attribute(isOn: weakSelf.tabbar.index == selectedIndex)
        }).disposed(by: disposeBag)
    }
}

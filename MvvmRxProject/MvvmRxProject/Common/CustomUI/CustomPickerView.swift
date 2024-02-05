//
//  CustomPickerView.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2/5/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


struct PickerData{
    var type: UIDatePicker.Mode?
    var dataSource: PickerDataProtocol?
}

class CustomPicker: UIViewController {
    var selectDataObservable = PublishSubject<[String: String]>()
    
    var data: PickerData
    var index: Int
    
    var bgButton = UIButton().then{
        $0.backgroundColor = .black.withAlphaComponent(0)
    }
    var containerView = UIView().then{
        $0.backgroundColor = .white
    }
    
    private var pickerView = UIPickerView().then{
        $0.backgroundColor = .white
        $0.tintColor = .black
        
        $0.isHidden = true
    }
    private let datePicker = UIDatePicker().then{
        $0.backgroundColor = .white
        $0.tintColor = .black
        $0.isHidden = true
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
    }
                
    var toolbarView = UIView().then{
        $0.backgroundColor = .gray
    }
    
    var doneButton = UIButton().then{
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
    }
            
    var selectedDepth: PickerDataTypeProtocol?
    var selectedData: [String: String] = [:]
    let disposeBag = DisposeBag()
    
    init(data: PickerData, index: Int){
        self.data = data
        self.index = index
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = .overFullScreen
        layout()
        attribute()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    func layout(){
        toolbarView.addSubview(doneButton)
        containerView.addSubview(pickerView)
        containerView.addSubview(datePicker)
        containerView.addSubview(toolbarView)
        
        self.view.addSubview(bgButton)
        self.view.addSubview(containerView)
        
        bgButton.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(240 + 50)
            $0.bottom.equalToSuperview().offset(295)
        }
        
        toolbarView.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        doneButton.snp.makeConstraints{
            $0.width.equalTo(50)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        pickerView.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(toolbarView.snp.bottom)
        }
        
        datePicker.snp.makeConstraints{
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(toolbarView.snp.bottom)
        }
    }
    
    func attribute(){
        self.datePicker.isHidden = self.data.type == nil
        self.pickerView.isHidden = self.data.type != nil
    }
    
    func bind(){
        bgButton.rx.tap
             .subscribe({[weak self] _ in
                 guard let weakSelf = self else { return }
                 weakSelf.selectDataObservable.onCompleted()
                 weakSelf.dismissAnimation()
        }).disposed(by: disposeBag)

       doneButton.rx.tap
            .subscribe({[weak self] _ in
                guard let weakSelf = self else { return }
                if weakSelf.data.type != .date && weakSelf.data.type != .time {
                    weakSelf.selectDataObservable.onNext(weakSelf.selectedData)
                }
                weakSelf.selectDataObservable.onCompleted()
                weakSelf.dismissAnimation()
       }).disposed(by: disposeBag)
       
        if let mode = self.data.type {
            datePicker.datePickerMode = mode
            datePicker.minuteInterval = 5
        }else {
            selectedDepth = data.dataSource?.totalList[0]
            selectedData = ["key0": "\(data.dataSource?.totalList[0].data ?? "")",
                            "key1": "\(data.dataSource?.totalList[0].subList[0] ?? "")"]            
            self.pickerView.dataSource = self
            self.pickerView.delegate = self
        }
        
        datePicker.rx.value
            .asObservable()
            .subscribe(onNext:{[weak self] date in
                guard let weakSelf = self else { return }
                weakSelf.selectDataObservable.onNext(["key0": "\(date.convertToString(formatType: .total(date: .slash, time: .full24)))"])
            }).disposed(by: disposeBag)                           
    }
    
    func startAnimation(){
        
        UIView.animate(
            withDuration: 0.2,
          delay: 0,
          options: .curveEaseInOut,
          animations: {
              self.bgButton.backgroundColor = .black.withAlphaComponent(0.2)
              self.containerView.snp.updateConstraints{
                  $0.bottom.equalToSuperview()
              }
              self.view.layoutIfNeeded()
          },
          completion: nil
        )
    }
    
    func dismissAnimation(){
        UIView.animate(
            withDuration: 0.2,
          delay: 0,
          options: .curveEaseInOut,
          animations: {
              self.bgButton.alpha = 0
              self.containerView.snp.updateConstraints{
                  $0.bottom.equalToSuperview().offset(295)
              }
              self.view.layoutIfNeeded()
          },
            completion: {_ in 
                self.dismiss(animated: false)
            }
        )
    }
}

extension CustomPicker: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.dataSource?.componentsCount ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return data.dataSource?.totalList.count ?? 0
        }else if let selectedDepth = selectedDepth {
            return data.dataSource?.getSubList(with: selectedDepth).count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}

extension CustomPicker: UIPickerViewDelegate {
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let list = self.data.dataSource else { return  UIView() }
    
        let label = UILabel().then{
            $0.textColor = .black
        }
        
        label.frame.size = CGSize.init(width: 80, height: 40)
        if component == 0 {
            label.textAlignment = .right
            label.text = list.totalList[row].data
        }else if let selectedDepth = selectedDepth {
            label.textAlignment = .left
            label.text = list.getSubList(with: selectedDepth)[row]
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let list = self.data.dataSource else { return }
        
        switch component {
        case 0:
            selectedDepth = list.totalList[row]
            selectedData["key\(component)"] = list.totalList[row].data
            selectedData["key\(component+1)"] = list.getSubList(with: selectedDepth!)[0]
            
            pickerView.reloadAllComponents()
        case 1:
            if let selectedDepth = selectedDepth {
                selectedData["key\(component)"] = list.getSubList(with: selectedDepth)[row]
            }
        default:
            return
        }
    }
}

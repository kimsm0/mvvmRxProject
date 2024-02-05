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
    var dataSource: [Any]?
}

class CustomPicker: UIViewController {
    
    var data: PickerData
    var index: Int
    
    var bgButton = UIButton().then{
        $0.backgroundColor = .black.withAlphaComponent(0.2)
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
    
    let customLabel = UILabel().then{
        $0.backgroundColor = .yellow
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 13)
    }
            
    var firstPickerRow: Int = 0
    let disposeBag = DisposeBag()
    
    init(data: PickerData, index: Int){
        self.data = data
        self.index = index
        super.init(nibName: nil, bundle: nil)
        layout()
        attribute()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(240 + 50)
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
                 weakSelf.dismiss(animated: false)
        }).disposed(by: disposeBag)

       doneButton.rx.tap
            .subscribe({[weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.dismiss(animated: false)
       }).disposed(by: disposeBag)
       
        if let mode = self.data.type {
            datePicker.datePickerMode = mode
            datePicker.minuteInterval = 5
        }else {
            self.pickerView.dataSource = self
            self.pickerView.delegate = self
        }
    }
}

extension CustomPicker: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {        
        switch component {
            case 0:
                if let list = self.data.dataSource as? [RegionData.Region] {
                    return list.count
                }
            case 1:
                if let list = self.data.dataSource as? [RegionData.Region] {
                    return list[firstPickerRow].guList.count
                }
            default:
                return 0
            }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}

extension CustomPicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let list = self.data.dataSource as? [RegionData.Region] else { return nil }
        
        switch component {
        case 0:
            return list[row].city.rawValue
        case 1:
            return list[firstPickerRow].guList[row]
        default:
            return nil
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let list = self.data.dataSource as? [RegionData.Region] else { return  UIView() }
    
        let label = UILabel().then{
            $0.textColor = .black
        }
        
        label.frame.size = CGSize.init(width: 80, height: 40)
        if component == 0 {
            label.textAlignment = .right
            label.text = list[row].city.rawValue
        }else{
            label.textAlignment = .left
            label.text = list[firstPickerRow].guList[row]
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let list = self.data.dataSource as? [RegionData.Region] else { return }
        
        switch component {
        case 0:
            firstPickerRow = row
            pickerView.reloadAllComponents()
        case 1:
            let selectedItem = list[firstPickerRow]            
        default:
            return
        }
    }
}

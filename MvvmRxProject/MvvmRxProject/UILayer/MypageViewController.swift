//
//  MypageViewController.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2/3/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Photos
import AssetsLibrary
import MobileCoreServices

class MypageViewController: CommonViewController {
    
    var pickerButton = UIButton().then{
        $0.setTitle("Custom Picker Test", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
    }
    var pickerDataLabel = UILabel().then{
        $0.textColor = .blue
        $0.font = .boldSystemFont(ofSize: 18)
    }
    
    var datePickerButton = UIButton().then{
        $0.setTitle("Date Picker Test", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
    }
    
    var timePickerButton = UIButton().then{
        $0.setTitle("Time Picker Test", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
    }
    
    var cameraButton = UIButton().then{
        $0.setTitle("Camera Test", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
    }
    var photoImageView = UIImageView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func layout(){
        self.view.addSubview(pickerButton)
        self.view.addSubview(datePickerButton)
        self.view.addSubview(timePickerButton)
        self.view.addSubview(pickerDataLabel)
        self.view.addSubview(cameraButton)
        self.view.addSubview(photoImageView)
        
        pickerButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.height.equalTo(50)
        }
        datePickerButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(pickerButton.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        timePickerButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(datePickerButton.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        
        pickerDataLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(timePickerButton.snp.bottom).offset(20)
            $0.height.equalTo(30)
        }
        
        cameraButton.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(pickerDataLabel.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        
        photoImageView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(cameraButton.snp.bottom).offset(20)
            $0.height.equalTo(200)
        }
    }
    
    override func attribute() {
        super.attribute()
    }
    
    func bind(){
        pickerButton.rx.tap
            .subscribe(onNext:{[weak self] _ in
                guard let weakSelf = self else { return }
                let picker = CustomPicker(data: PickerData(dataSource: RegionData()), index: 0)
                picker.selectDataObservable
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { dataDic in
                        let result = "\(dataDic["key0"] ?? "-") \(dataDic["key1"] ?? "-")"
                        weakSelf.pickerDataLabel.text = result
                }).disposed(by: weakSelf.disposeBag)                
                weakSelf.present(picker, animated: false)
                
            }).disposed(by: disposeBag)
        
        datePickerButton.rx.tap
            .subscribe(onNext:{[weak self] _ in
                guard let weakSelf = self else { return }
                let picker = CustomPicker(data: PickerData(type: .date), index: 0)
                picker.selectDataObservable
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { dataDic in
                        let result = "\(dataDic["key0"] ?? "-") \(dataDic["key1"] ?? "-")"
                        weakSelf.pickerDataLabel.text = result
                }).disposed(by: weakSelf.disposeBag)
                weakSelf.present(picker, animated: false)
                
            }).disposed(by: disposeBag)
        
        timePickerButton.rx.tap
            .subscribe(onNext:{[weak self] _ in
                guard let weakSelf = self else { return }
                let picker = CustomPicker(data: PickerData(type: .time), index: 0)
                picker.selectDataObservable
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { dataDic in
                        let result = "\(dataDic["key0"] ?? "-") \(dataDic["key1"] ?? "-")"
                        weakSelf.pickerDataLabel.text = result
                }).disposed(by: weakSelf.disposeBag)
                weakSelf.present(picker, animated: false)
                
            }).disposed(by: disposeBag)
        
        cameraButton.rx.tap
            .subscribe(onNext:{[weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.actionSheet(weakSelf,
                                 nil, nil,
                                 UIAlertAction(title: "photo_shooting_title".localized(), style: .default, handler:{ action in weakSelf.camera() }),
                                 UIAlertAction(title: "select_from_album_title".localized(), style: .default , handler:{ action in weakSelf.album() }),
                                 UIAlertAction(title: "cancel_title".localized(), style: .cancel, handler:{ action in weakSelf.dismiss(animated: true, completion: nil ) })
                                 )
                
            }).disposed(by: disposeBag)
    }
}

extension MypageViewController {
    
    func actionSheet(_ controller:UIViewController, _ title:String?, _ message:String?, _ actions: UIAlertAction...) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        if UIDevice.current.userInterfaceIdiom == .pad {
            guard let popoverController = alertController.popoverPresentationController  else { return }

            popoverController.sourceView = controller.view
            popoverController.sourceRect = CGRect(x: 30, y: controller.view.center.y - CGFloat(actions.count * 30) , width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        actions.forEach {
            alertController.addAction($0)
        }

        controller.present(alertController, animated: true, completion: nil)
    }
    
    func camera() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) {
            authStatus in
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authStatus {
            case .authorized:
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    DispatchQueue.main.async {
                        let picker = UIImagePickerController()
                        picker.allowsEditing = false
                        picker.sourceType = UIImagePickerController.SourceType.camera
                        picker.cameraCaptureMode = .photo
                        picker.modalPresentationStyle = .fullScreen
                        picker.delegate = self
                        
                        self.present(picker, animated: true, completion: nil)
                    }
                }
                break
            case .denied, .notDetermined:
                DispatchQueue.main.async {
                    Alert.showAlertVC(message: "권한", cancelTitle: nil, confirmAction: nil, cancelAction: nil)
                }
                
                break
            default:
                DispatchQueue.main.async {
                    Alert.showAlertVC(message: "권한", cancelTitle: nil, confirmAction: nil, cancelAction: nil)
                }
                
                break
            }
        }
    }
    
    //MARK: show album
    
    func album() {
        
        PHPhotoLibrary.requestAuthorization({
            status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.delegate = self
                        imagePickerController.allowsEditing = false
                        imagePickerController.sourceType = .savedPhotosAlbum
                        imagePickerController.modalPresentationStyle = .fullScreen
                        
                        self.present(imagePickerController, animated: true, completion: nil)
            
                    }
                }
                break
            case .denied , .notDetermined , .restricted :
                DispatchQueue.main.async {
                    Alert.showAlertVC(message: "권한", cancelTitle: nil, confirmAction: nil, cancelAction: nil)
                }
                break
            default:
                fatalError()
            }
        })
    }
}

//MARK: UIImagePickerControllerDelegate

extension MypageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        let pickerControllerOriginalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage

        guard var image = pickerControllerOriginalImage else {
            return
        }

        let maxPixel: CGFloat = 600

        if image.size.width > maxPixel {
            let width = maxPixel
            let height = (image.size.height * maxPixel) / image.size.width

            image = imagePressed(image, CGSize(width: width, height: height))
        } else if image.size.height > maxPixel {
            let width = (image.size.width * maxPixel) / image.size.height
            let height = maxPixel

            image = imagePressed(image, CGSize(width: width, height: height))
        }

        picker.dismiss(animated: true, completion: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.photoImageView.image = image
        })
    }

    func imagePressed(_ image: UIImage, _ toSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(toSize)
        image.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()

        return result!
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

//
//  Region.swift
//  MvvmRxProject
//
//  Created by kimsoomin_mac2022 on 2/5/24.
//

import Foundation

protocol PickerDataProtocol{
    var componentsCount: Int { get set}
    var totalList: [PickerDataTypeProtocol] { get set }
    func getSubList(with type: PickerDataTypeProtocol) -> [String]
}

protocol PickerDataTypeProtocol{
    var data: String { get }
    var subList: [String] { get }
}

enum City: String, PickerDataTypeProtocol {
    
    case seoul = "서울시"
    case gangwon = "강원도"
    case gyeonggi = "경기도"
    case gyeongsang = "경상도"
    case gwangju = "광주시"
    case daegu = "대구시"
    case daejeon = "대전시"
    case busan = "부산시"
    case ulsan = "울산시"
    case incheon = "인천시"
    case jeonlado = "전라도"
    case chungcheong = "충성도"
    case jeju = "제주시"
    
    var data: String {
        return self.rawValue
    }
    
    var subList: [String] {
        switch self {
        case .seoul:
            return ["강남구", "강동구","강북구","강서구","관악구","광진구","구로구","금천구","노원구","도봉구","동대문구","동작구","마포구","서대문구","서초구","성동구","성북구","송파구","양천구","영등포구","용산구","은평구","종로구","중구","중랑구"]
        case .gangwon:
            return ["강릉시","동해시","삼척시","속초시","양구군","원주시","정선군","춘천시","태백시","홍천군"]
        case .gyeonggi:
            return ["강화군","고양시","과천시","광명시","광주시","구리시","군포시","김포시","남양주시","동두천시","부천시","성남시","수원시","시흥시","안산시","안성시","안양시","양주시","양평군","여주시","오산시","옹진군","용인시","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시"]
        case .gyeongsang:
            return ["거제시","거창군","경산시","경주시","고성군","구미시","기장군","김천시","김해시","남해군","마산시","문경시","밀양시","사천시","상주시","안동시","양산시","영주시","영천시","울진군","진주시","진해시","창원시","칠곡군","통영시","포항시"]
        case .gwangju:
            return ["광산구","남구","동구","북구","서구"]
        case .daegu:
            return ["달서구","수성구","남구","달성군","동구","북구","서구","중구"]
        case .daejeon:
            return ["대덕구","동구","서구","유성구","중구"]
        case .busan:
            return ["강서구","금정구","남구","동구","동래구","부산진구","북구","사상구","사하구","서구","수영구","연제구","중구","해운대구","기장군"]
        case .ulsan:
            return ["남구","동구","북구","중구"]
        case .incheon:
            return ["강화군","계양구","남구","동구","남동구","미추홀구","부평구","서구","연수구","중구"]
        case .jeonlado:
            return ["광양시","군산시","김제시","나주시","남원시","목포시","무안군","보성군","부안군","순천시","여수시","영광군","익산시","전주시","정읍시","해남군","화순군"]
        case .chungcheong:
            return ["공주시","괴산군","금산군","세종시","논산시","단양군","당진시","보령시","부여군","서산시","아산시","예산군","제천시","조치원읍","증평군","천안시","청주시","충주시","홍성군"]
        case .jeju:
            return ["서귀포시","제주시"]
        default:
            return []
        }
    }
}

struct RegionData: PickerDataProtocol {
    var componentsCount: Int = 2
    var totalList: [PickerDataTypeProtocol]
            
    init() {
        self.componentsCount = 2
        self.totalList = [City.seoul, City.gangwon, City.gyeonggi, City.gyeongsang, City.gwangju, City.daegu, City.daejeon, City.busan, City.ulsan, City.incheon, City.jeonlado, City.chungcheong, City.jeju]
    }
    
    func getSubList(with type: PickerDataTypeProtocol) -> [String] {
        return type.subList
    }
}

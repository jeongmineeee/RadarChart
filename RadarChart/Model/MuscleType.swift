//
//  MuscleType.swift
//  RadarChart
//
//  Created by 홍정민 on 4/22/25.
//

import Foundation

// MARK: - 근육 데이터 구성
struct MuscleData {
    let type: MuscleType
    let value: Double
    let side: Side?
    
    init(type: MuscleType, value: Double, side: Side? = .front) {
        self.type = type
        self.value = value
        self.side = side
    }
}

// 근육질 테스트 데이터
let dataList: [MuscleData] = [
    MuscleData(type: .큰가슴근, value: 50.2),
    MuscleData(type: .심지굴근, value: 70.3),
    MuscleData(type: .삼각근_앞, value: 40.3),
    MuscleData(type: .복근, value: 50.5),
    MuscleData(type: .대퇴근, value: 60.6),
    MuscleData(type: .이두근, value: 90.2)
]

let newDataList: [MuscleData] = [
    MuscleData(type: .큰가슴근, value: 50.2),
    MuscleData(type: .심지굴근, value: 70.3),
    MuscleData(type: .삼각근_앞, value: 40.3),
    MuscleData(type: .복근, value: 50.5),
    MuscleData(type: .대퇴근, value: 60.6),
    MuscleData(type: .이두근, value: 90.2),
    MuscleData(type: .이두근, value: 100.0)
]

// 근육양 테스트 데이터
let frontQuantityList: [MuscleData] = [
    MuscleData(type: .큰가슴근, value: 50.2, side: .front),
    MuscleData(type: .심지굴근, value: 70.3, side: .front),
    MuscleData(type: .삼각근_앞, value: 40.3, side: .front),
    MuscleData(type: .복근, value: 50.5, side: .front),
    MuscleData(type: .대퇴근, value: 60.6, side: .front),
    MuscleData(type: .이두근, value: 90.2, side: .front),
]

let backQuantityList: [MuscleData] = [
    MuscleData(type: .큰가슴근, value: 80, side: .back),
    MuscleData(type: .심지굴근, value: 60.3, side: .back),
    MuscleData(type: .삼각근_앞, value: 40.3, side: .back),
    MuscleData(type: .복근, value: 70.3, side: .back),
    MuscleData(type: .대퇴근, value: 30.6, side: .back),
    MuscleData(type: .이두근, value: 70.2, side: .back)
]

// MARK: 관련 Enum 정의
enum Side: String {
    case front
    case back
}

protocol MuscleName {
    var name: String { get }
}

enum MuscleType: String, CaseIterable, MuscleName {
    case 큰가슴근
    case 심지굴근
    case 삼각근_앞
    case 복근
    case 대퇴근
    case 이두근
    
    var name: String {
        switch self {
        case .삼각근_앞:
            return "삼각근(앞)"
        default:
            return self.rawValue
        }
    }
}

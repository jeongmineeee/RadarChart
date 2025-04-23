//
//  MuscleType.swift
//  RadarChart
//
//  Created by 홍정민 on 4/22/25.
//

import Foundation

struct MuscleData {
    let type: MuscleType
    let value: Double
    
}

let dataList: [MuscleData] = [
    MuscleData(type: .큰가슴근, value: 50.2),
    MuscleData(type: .심지굴근, value: 70.3),
    MuscleData(type: .삼각근_앞, value: 40.3),
    MuscleData(type: .복근, value: 50.5),
    MuscleData(type: .대퇴근, value: 60.6),
    MuscleData(type: .이두근, value: 90.2)
]

enum MuscleType: String, CaseIterable {
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



//
//  CGPoint+.swift
//  RadarChart
//
//  Created by 홍정민 on 4/23/25.
//

import Foundation

extension CGPoint {
    func moving(distance: CGFloat, atAngle angle: CGFloat) -> CGPoint {
        CGPoint(
            x: x + distance * cos(angle),
            y: y + distance * sin(angle)
        )
    }
}

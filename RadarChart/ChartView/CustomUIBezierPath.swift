//
//  CustomUIBezierPath.swift
//  RadarChart
//
//  Created by 홍정민 on 4/22/25.
//

import UIKit

final class CustomUIBezierPath: UIBezierPath {
    var movePoint: CGPoint?

    override func move(to point: CGPoint) {
        super.move(to: point)
        movePoint = point
    }
}

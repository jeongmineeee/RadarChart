//
//  RadarChartView.swift
//  RadarChart
//
//  Created by 홍정민 on 4/22/25.
//

import UIKit

final class RadarGraphView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        var radian: Double = 0
        var points: [CGPoint] = []
        
        // 레벨 설정
        let step = 5
        var stepLinePaths = [CustomUIBezierPath]()
        for _ in 0 ..< step {
            stepLinePaths.append(CustomUIBezierPath())
        }
        
        //  꼭지점과 중앙을 연결하는 패스
        var connectLinePaths = [UIBezierPath]()
        
        // 최대로 그려질 높이 설정
        // 1단계에 해당하는 높이 설정
        let heightMaxValue = rect.height / 2 * 0.7
        let heightStep = heightMaxValue / CGFloat(step)
        
        // 중심점
        let cx = rect.midX
        let cy = rect.midY
        
        // 그리는 지점(중심점보다 위에서 시작)
        let x = rect.midX
        let y = rect.midY - heightMaxValue
        
        // 실질적으로 특성값을 표시할 UIBezierPath
        let valuePath = UIBezierPath()
        
        MuscleType.allCases.forEach { type in
            // 차트 중심으로부터 각 특성 다각형 꼭지점까지의 직선
            UIColor.lightGray.setStroke()
            let path = UIBezierPath()
            path.lineWidth = 0.8
            path.move(to: CGPoint(x: cx, y: cy))
            path.addLine(to: transformRotate(radian: radian, x: x, y: y, cx: cx, cy: cy))
            connectLinePaths.append(path)
            
            let partialPath = UIBezierPath()
            partialPath.lineWidth = 0.8
            partialPath.move(to: CGPoint(x: cx, y: cy))
            partialPath.addLine(to: transformRotate(radian: radian, x: x, y: y, cx: cx, cy: cy))
            partialPath.stroke()
            
            // 단계별 가이드 라인 path 설정
            stepLinePaths.enumerated().forEach { index, path in
                let point = transformRotate(radian: radian, x: x, y: y + heightStep * CGFloat(index), cx: cx, cy: cy)
                if path.isEmpty {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            
            // 각 꼭지점에 근육명칭 작성
            let font = UIFont.systemFont(ofSize: 12)
            let strValue = type.name
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            
            // 문자열의 대략적인 크기 계산
            let size = strValue.size(withAttributes: attributes)
            let point = transformRotate(radian: radian, x: x, y: y * 0.6, cx: cx, cy: cy)
            
            // 텍스트를 중심에 맞게 위치 계산
            let textRect = CGRect(
                x: point.x - size.width / 2,
                y: point.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            
            // 문자열 그리기
            strValue.draw(in: textRect, withAttributes: attributes)
            
            // 실제 데이터 반영
            // 각 포인트에 점으로 강조
            if let value = dataList.first(where: { $0.type == type })?.value {
                
                let convValue = heightMaxValue * (CGFloat(value) / 100) // 전달된 값을 차트크기에 맞게 변환(높이대비)
                let point = transformRotate(radian: radian, x: x, y: rect.midY - convValue, cx: cx, cy: cy)
                
                points.append(point)
                
                if valuePath.isEmpty {
                    valuePath.move(to: point)
                } else {
                    valuePath.addLine(to: point)
                }
            }
            
            // 각도 변경
            radian += .pi * 2 / Double(MuscleType.allCases.count)
        }
        
        // 단계별 가이드 라인이 실질적으로 그려짐
        stepLinePaths.enumerated().forEach { index, path in
            print(index, path)
            switch index {
            case 2...4:
                UIColor.fillGreen.setFill()
            case 1:
                UIColor.fillBlue.setFill()
            case 0:
                UIColor.fillOrange.setFill()
            default:
                UIColor.gray.withAlphaComponent(0.2).setFill()
            }
            path.fill()
            
            // 가이드 선 작성
            UIColor.lightGray.setStroke()
            path.close()
            path.stroke()
            
            // 기준값 작성
            if let movePoint = path.movePoint {
                let strValue = "\(100 - 20 * index)"
                let font = UIFont.systemFont(ofSize: 8)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: UIColor.black
                ]
                
                let size = strValue.size(withAttributes: attributes)
                strValue.draw(
                    with: CGRect(
                        x: movePoint.x + 3,
                        y: movePoint.y - size.height,
                        width: size.width,
                        height: size.height
                    ),
                    options: .usesLineFragmentOrigin,
                    attributes: attributes,
                    context: nil
                )
            }
        }
        
        // 다각형 배경색 설정
//        UIColor.fillPink.withAlphaComponent(0.5).setFill()
//        valuePath.close()
//        valuePath.fill()
        
        UIColor.lightGray.setStroke()
        connectLinePaths.forEach { path in
            path.stroke()
        }
        
        // 다각형 테두리 설정
        UIColor.black.setStroke()
        valuePath.lineWidth = 2
        valuePath.close()
        valuePath.stroke()
        
        // 다각형 포인터 설정
        // 포인트에 값을 찍을 UIBezierPath
        for point in points {
            let pointPath = UIBezierPath()
            pointPath.addArc(
                withCenter: point,
                radius: 3, // 반지름
                startAngle: 0, // 0도
                endAngle: .pi * 2, // 360도
                clockwise: true // 시계방향 유무
            )
            UIColor.black.setFill()
            pointPath.fill()
        }
               
    }
    
    // 점(x, y)를 특정 좌표(cx, cy)를 중심으로 radian만큼 회전시킨 점의 좌표를 반환
    private func transformRotate(radian: Double, x: CGFloat, y: CGFloat, cx: CGFloat, cy: CGFloat) -> CGPoint {
        let x2 = cos(radian) * Double(x - cx) - sin(radian) * Double(y - cy) + Double(cx)
        let y2 = sin(radian) * Double(x - cx) + cos(radian) * Double(y - cy) + Double(cy)
        
        return CGPoint(x: x2, y: y2)
    }
}

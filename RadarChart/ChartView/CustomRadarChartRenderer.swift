//
//  CustomRadarChartRenderer.swift
//  RadarChart
//
//  Created by 홍정민 on 4/23/25.
//

import UIKit
import DGCharts

/// Radar Chart 커스텀에 필요한 클래스
final class CustomRadarChartRenderer: RadarChartRenderer {
    
    override func drawExtras(context: CGContext) {
        super.drawExtras(context: context)
        
        guard let chart = chart else { return }
        context.saveGState()
        
        let center = chart.centerOffsets
        let radius = chart.radius
        let sliceAngle = chart.sliceAngle
        let entryCount = chart.data?.maxEntryCountSet?.entryCount ?? 0
        
        let levels: [(CGFloat, CGFloat, UIColor)] = [
            (0.0, 0.6, UIColor(hex: "#FF9500").withAlphaComponent(0.1)),  // 0~60
            (0.6, 0.8, UIColor(hex: "#007AFF").withAlphaComponent(0.1)),    // 60~80
            (0.8, 1.0, UIColor(hex: "#00FF00").withAlphaComponent(0.1))    // 80~100
        ]
        
        for (innerRatio, outerRatio, color) in levels {
            // 영역을 그릴 패스 설정
            let path = UIBezierPath()
            
            // 외부 원 경로 (시계 방향)
            for i in 0..<entryCount {
                let angle = sliceAngle * CGFloat(i) + chart.rotationAngle
                let point = CGPoint(
                    x: center.x + radius * outerRatio * cos(angle * .pi / 180),
                    y: center.y + radius * outerRatio * sin(angle * .pi / 180)
                )
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            
            path.close()
            
            // 내부 원 경로 (반시계 방향)
            for i in (0..<entryCount).reversed() {
                let angle = sliceAngle * CGFloat(i) + chart.rotationAngle
                let point = CGPoint(
                    x: center.x + radius * innerRatio * cos(angle * .pi / 180),
                    y: center.y + radius * innerRatio * sin(angle * .pi / 180)
                )
                if i == entryCount - 1 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            
            path.close()
            
            context.setFillColor(color.cgColor)
            context.addPath(path.cgPath)
            context.fillPath()
        }
        
        context.restoreGState()
    }
    
    override func drawValues(context: CGContext) {
        guard let chart = chart,
              let radarData = chart.data else { return }
        
        let sliceAngle = chart.sliceAngle
        let factor = chart.factor
        let center = chart.centerOffsets
        let rotationAngle = chart.rotationAngle
        let chartYMin = chart.chartYMin
        let labelPadding: CGFloat = 13.0
        
        for i in 0..<radarData.dataSets.count {
            let dataSet = radarData.dataSets[i] as! RadarChartDataSet
            
            if !dataSet.isDrawValuesEnabled || dataSet.count == 0 {
                continue
            }
            
            for j in 0..<dataSet.count {
                let entry = dataSet[j]
                
                let angle = sliceAngle * CGFloat(j) + rotationAngle
                let value = entry.y
                let r = (value - chartYMin) * factor + labelPadding
                
                let labelPosition = center.moving(distance: r, atAngle: angle.radians)
                
                let valueText = dataSet.valueFormatter.stringForValue(
                    value,
                    entry: entry,
                    dataSetIndex: i,
                    viewPortHandler: viewPortHandler
                )
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: dataSet.valueFont,
                    .foregroundColor: dataSet.valueTextColor
                ]
                
                drawText(
                    context: context,
                    text: valueText,
                    at: labelPosition,
                    align: .center,
                    attributes: attributes
                )
                
            }
        }
    }

}

extension CustomRadarChartRenderer {
    func drawText(
        context: CGContext,
        text: String,
        at point: CGPoint,
        align: NSTextAlignment,
        attributes: [NSAttributedString.Key: Any]
    ) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = align
        
        var attributesWithAlignment = attributes
        attributesWithAlignment[.paragraphStyle] = paragraphStyle
        attributesWithAlignment[.font] = UIFont.systemFont(ofSize: 10)
        
        let size = text.size(withAttributes: attributesWithAlignment)
        let rect = CGRect(
            x: point.x - size.width / 2,
            y: point.y - size.height / 2,
            width: size.width,
            height: size.height
        )
        
        text.draw(in: rect, withAttributes: attributesWithAlignment)
    }
}

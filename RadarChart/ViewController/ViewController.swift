//
//  ViewController.swift
//  RadarChart
//
//  Created by 홍정민 on 4/22/25.
//

import UIKit
import SnapKit
import DGCharts

final class ViewController: UIViewController {
    private let radarChartView = RadarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureView()
        setChartData()
    }
    
    private func configureHierarchy() {
        view.addSubview(radarChartView)
    }
    
    private func configureLayout() {
        radarChartView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
    }
    
    private func configureView() {
        radarChartView.chartDescription.enabled = false
        radarChartView.webLineWidth = 1
        radarChartView.innerWebLineWidth = 1
        radarChartView.webColor = .lightGray
        radarChartView.innerWebColor = .lightGray
        radarChartView.webAlpha = 1
        radarChartView.rotationEnabled = false
        radarChartView.legend.enabled = false
    }
    
    private func setChartData() {
        // 차트에 사용할 실 데이터
        let muscles = MuscleType.allCases.map { $0.name }
        
        // 데이터셋을 만들 엔트리 배열을 설정
        let entries = dataList.map { RadarChartDataEntry(value: $0.value) }

        // 실제 데이터 세트 생성
        let dataSet = RadarChartDataSet(entries: entries, label: "근육질")
        dataSet.colors = [.black]
        dataSet.fillColor = UIColor.clear
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 0.7
        dataSet.lineWidth = 1
        dataSet.drawValuesEnabled = true
        
        // 차트와 데이터 연동
        let data = RadarChartData(dataSet: dataSet)
        radarChartView.data = data // 데이터셋을 데이터로 지정
        radarChartView.highlightPerTapEnabled = false // 하이라이트 지점 터치 이벤트 방지
        radarChartView.isUserInteractionEnabled = false // 차트 자체에 대한 인터랙션 방지

        // 차트에 커스텀 랜더러 설정
        // 데이터 값이나 배경을 그릴 필요가 있어 커스텀 랜더러를 사용함
        radarChartView.renderer = CustomRadarChartRenderer(chart: radarChartView,
                                                            animator: radarChartView.chartAnimator,
                                                            viewPortHandler: radarChartView.viewPortHandler)
        
        // 하이라이트(데이터값의 꼭짓점) 설정
        // 하이라이트를 설정한다고 해도, 차트 자체에 하이라이트 값을 설정하지 않으면 표시 되지 않음
        // radarChartView.highlightValues(highlights)
        dataSet.drawHighlightCircleEnabled = true
        dataSet.setDrawHighlightIndicators(false)
        dataSet.highlightCircleFillColor = .black
        dataSet.highlightCircleStrokeColor = .black
        dataSet.highlightCircleOuterRadius = 2
        dataSet.highlightCircleInnerRadius = 0
        
         let highlights = dataList.enumerated().map { index, item in
             Highlight(x: Double(index), y: item.value, dataSetIndex: 0)
         }
        radarChartView.highlightValues(highlights)
        
        // X축 설정
        radarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: muscles)
        radarChartView.xAxis.labelFont = .systemFont(ofSize: 10)
        radarChartView.xAxis.labelTextColor = .darkGray
        
        // Y축 설정
        radarChartView.yAxis.axisMinimum = 20 // 처음 시작점(0 제외)을 20으로 지정
        radarChartView.yAxis.axisMaximum = 100
        radarChartView.yAxis.labelCount = 5
        radarChartView.yAxis.drawLabelsEnabled = false // Y축 값(20, 40, 60) 등은 표시하지 않음
    }
}

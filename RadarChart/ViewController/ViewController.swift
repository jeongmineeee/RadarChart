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
    private let basicRadarChartView = RadarChartView()
    private let changeButton = UIButton()
    private var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureView()
        
        // 차트 데이터 세팅
        setChartData() // 근육질 차트
        setBasicChartData() // 근육양 차트
    }
    
    private func configureHierarchy() {
        view.addSubview(radarChartView)
        view.addSubview(basicRadarChartView)
        view.addSubview(changeButton)
    }
    
    private func configureLayout() {
        radarChartView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        
        basicRadarChartView.snp.makeConstraints { make in
            make.top.equalTo(radarChartView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(250)
        }
        
        changeButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
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
        
        basicRadarChartView.chartDescription.enabled = false
        basicRadarChartView.webLineWidth = 1
        basicRadarChartView.innerWebLineWidth = 1
        basicRadarChartView.webColor = .lightGray
        basicRadarChartView.innerWebColor = .lightGray
        basicRadarChartView.webAlpha = 1
        basicRadarChartView.rotationEnabled = false
        basicRadarChartView.legend.enabled = false
        
        changeButton.layer.cornerRadius = 10
        changeButton.backgroundColor = .strokePink
        changeButton.tintColor = .white
        changeButton.setTitle("7개로 변경하기", for: .normal)
        changeButton.addTarget(self, action: #selector(changeButtonClicked), for: .touchUpInside)
    }
    
}

extension ViewController {
    @objc private func changeButtonClicked() {
        if !flag {
            changeButton.setTitle("6개로 변경하기", for: .normal)
            setNewChartData()
        } else {
            changeButton.setTitle("7개로 변경하기", for: .normal)
            setChartData()
        }
        
        flag.toggle()
    }
    
    private func setNewChartData() {
        let entries = newDataList.map { RadarChartDataEntry(value: $0.value) }
        let muscles = newDataList.map { $0.type.name }
        let dataSet = RadarChartDataSet(entries: entries, label: "근육질")
        
        dataSet.colors = [.black]
        dataSet.fillColor = UIColor.clear
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 0.7
        dataSet.lineWidth = 1
        dataSet.drawValuesEnabled = false
        dataSet.valueTextColor = .black

        
        // 차트에 커스텀 랜더러 설정
        // 데이터 값이나 배경을 그릴 필요가 있어 커스텀 랜더러를 사용함
        radarChartView.renderer = CustomRadarChartRenderer(chart: radarChartView,
                                                           animator: radarChartView.chartAnimator,
                                                           viewPortHandler: radarChartView.viewPortHandler)
        
        // X축 설정
        radarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: muscles)
        radarChartView.xAxis.labelFont = .systemFont(ofSize: 10)
        radarChartView.xAxis.labelTextColor = .darkGray
        
        // Y축 설정
        radarChartView.yAxis.axisMinimum = 20 // 처음 시작점(0 제외)을 20으로 지정
        radarChartView.yAxis.axisMaximum = 100
        radarChartView.yAxis.setLabelCount(6, force: true)
        radarChartView.yAxis.drawLabelsEnabled = false // Y축 값(20, 40, 60) 등은 표시하지 않음
        
        // 차트와 데이터 연동
        let data = RadarChartData(dataSet: dataSet)
        radarChartView.data = data // 데이터셋을 데이터로 지정
        radarChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutCirc)

    }
    
    private func setChartData() {
        let entries = dataList.map { RadarChartDataEntry(value: $0.value) }
        let muscles = dataList.map { $0.type.name }
        
        // 실제 데이터 세트 생성
        let dataSet = RadarChartDataSet(entries: entries, label: "근육질")
        dataSet.colors = [.black]
        dataSet.fillColor = UIColor.clear
        dataSet.drawFilledEnabled = true
        dataSet.fillAlpha = 0.7
        dataSet.lineWidth = 1
        dataSet.drawValuesEnabled = false
        dataSet.valueTextColor = .black
        
        // 차트에 커스텀 랜더러 설정
        // 데이터 값이나 배경을 그릴 필요가 있어 커스텀 랜더러를 사용함
        radarChartView.renderer = CustomRadarChartRenderer(chart: radarChartView,
                                                           animator: radarChartView.chartAnimator,
                                                           viewPortHandler: radarChartView.viewPortHandler)
        
        
        // X축 설정
        radarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: muscles)
        radarChartView.xAxis.labelFont = .systemFont(ofSize: 10)
        radarChartView.xAxis.labelTextColor = .darkGray
        
        // Y축 설정
        radarChartView.yAxis.axisMinimum = 0 // 처음 시작점(0 제외)을 20으로 지정
        radarChartView.yAxis.axisMaximum = 100
        radarChartView.yAxis.setLabelCount(6, force: true)
        radarChartView.yAxis.drawLabelsEnabled = false // Y축 값(20, 40, 60) 등은 표시하지 않음
        
        // 차트와 데이터 연동
        let data = RadarChartData(dataSet: dataSet)
        radarChartView.data = data // 데이터셋을 데이터로 지정
        radarChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutCirc)
    }
    
    private func setBasicChartData() {
        let muscles = MuscleType.allCases.map { $0.rawValue }
        
        // 전면부 데이터
        let frontEntries = frontQuantityList.map { RadarChartDataEntry(value: $0.value) }
        let frontDataSet = RadarChartDataSet(entries: frontEntries, label: "근육양(전면)")
        frontDataSet.colors = [.strokePink]
        frontDataSet.fillColor = .fillPink
        frontDataSet.fillAlpha = 0.7
        frontDataSet.lineWidth = 1
        frontDataSet.drawFilledEnabled = true
        frontDataSet.drawValuesEnabled = false
        
        frontDataSet.drawHighlightCircleEnabled = true
        frontDataSet.setDrawHighlightIndicators(false)
        frontDataSet.highlightCircleFillColor = .strokePink
        frontDataSet.highlightCircleStrokeColor = .strokePink
        frontDataSet.highlightCircleOuterRadius = 2
        frontDataSet.highlightCircleInnerRadius = 0
        
        // 후면부 데이터
        let backEntries = backQuantityList.map { RadarChartDataEntry(value: $0.value) }
        let backDataSet = RadarChartDataSet(entries: backEntries, label: "근육양(후면)")
        backDataSet.colors = [.fillGreen]
        backDataSet.fillColor = .fillGreen
        backDataSet.fillAlpha = 0.3
        backDataSet.lineWidth = 1
        backDataSet.drawFilledEnabled = true
        backDataSet.drawValuesEnabled = false
        
        backDataSet.drawHighlightCircleEnabled = true
        backDataSet.setDrawHighlightIndicators(false)
        backDataSet.highlightCircleFillColor = .fillGreen
        backDataSet.highlightCircleStrokeColor = .fillGreen
        backDataSet.highlightCircleOuterRadius = 2
        backDataSet.highlightCircleInnerRadius = 0
        
        // 데이터 설정
        let data = RadarChartData(dataSets: [frontDataSet, backDataSet])
        basicRadarChartView.data = data
        basicRadarChartView.highlightPerTapEnabled = false
        basicRadarChartView.isUserInteractionEnabled = false
        
        let frontHighlights = frontQuantityList.enumerated().map { index, item in
            Highlight(x: Double(index), y: item.value, dataSetIndex: 0)
        }
        
        let backHighlights = backQuantityList.enumerated().map { index, item in
            Highlight(x: Double(index), y: item.value, dataSetIndex: 1)
        }
        let highlights = frontHighlights + backHighlights
        basicRadarChartView.highlightValues(highlights)
        
        // X축 설정
        basicRadarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: muscles)
        basicRadarChartView.xAxis.labelFont = .systemFont(ofSize: 10)
        basicRadarChartView.xAxis.labelTextColor = .darkGray
        
        // Y축 설정
        basicRadarChartView.yAxis.axisMinimum = 20 // 처음 시작점(0 제외)을 20으로 지정
        basicRadarChartView.yAxis.axisMaximum = 100
        basicRadarChartView.yAxis.labelCount = 5
        basicRadarChartView.yAxis.drawLabelsEnabled = false // Y축 값(20, 40, 60) 등은 표시하지 않음
        
        basicRadarChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutCirc)
        
    }
}

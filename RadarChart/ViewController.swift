//
//  ViewController.swift
//  RadarChart
//
//  Created by 홍정민 on 4/22/25.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    let radarChartView = RadarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(radarChartView)
        radarChartView.backgroundColor = .white
        
        radarChartView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(400)
        }
    }


}


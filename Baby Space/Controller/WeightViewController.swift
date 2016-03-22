//
//  WeightViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import SwiftCharts

class WeightViewController: UIViewController {

    private var chart: Chart?
    private var avrWeightChart:Chart?
    @IBOutlet weak var weightView: UIView!
    
    @IBOutlet weak var avrWeightView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        let chartPoints = [(1, 22), (3, 23), (5, 24), (6, 25), (8, 25), (9, 26), (10, 26)].map{ChartPoint(x: ChartAxisValueInt($0.0), y: ChartAxisValueInt($0.1))}
        let avrWeight = [(1, 22), (3, 23), (5, 24), (6, 25), (8, 25), (9, 26), (10, 26)].map{ChartPoint(x: ChartAxisValueInt($0.0), y: ChartAxisValueInt($0.1))}
        let xValues = Array(1.stride(through: 12, by: 1)).map {ChartAxisValueInt($0, labelSettings: labelSettings)}
        let yValues = Array(20.stride(through: 30, by: 2)).map {ChartAxisValueInt($0, labelSettings: labelSettings)}
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "月份", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "体重", settings: labelSettings))
        
        let chartSettings = ExamplesDefaults.chartSettings
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: CGRectMake(1, 1, 300, 200), xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        // create layer with line
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor(red: 0.4, green: 0.4, blue: 1, alpha: 0.2), lineWidth: 3, animDuration: 0.7, animDelay: 0)
        let avrlineModel = ChartLineModel(chartPoints: avrWeight, lineColor: UIColor(red: 0.4, green: 0.4, blue: 1, alpha: 0.2), lineWidth: 3, animDuration: 0.7, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
        let avrChartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [avrlineModel])
        
        let circleViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            let circleView = ChartPointEllipseView(center: chartPointModel.screenLoc, diameter: 6)
            circleView.animDuration = 0.5
            circleView.fillColor = UIColor.redColor()
            return circleView
        }
        let chartPointsCircleLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints, viewGenerator: circleViewGenerator, displayDelay: 0, delayBetweenItems: 0.05)
        let avrChartPointsCircleLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: avrWeight, viewGenerator: circleViewGenerator, displayDelay: 0, delayBetweenItems: 0.05)
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth, dotWidth: 1.0, dotSpacing: 1.0)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        let chart = Chart(
            frame: CGRectMake(0, 0, 300, 200),
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                chartPointsLineLayer,
                chartPointsCircleLayer
            ]
        )
        
        let avrWeightChart = Chart(
            frame: CGRectMake(0, 0, 300, 200),
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                avrChartPointsLineLayer,
                avrChartPointsCircleLayer
            ]
        )

        
        self.weightView.addSubview(chart.view)
        self.avrWeightView.addSubview(avrWeightChart.view)
        self.chart = chart
        self.avrWeightChart = avrWeightChart
        
        
    }

}

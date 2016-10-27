//
//  StatisticsViewController.swift
//  SquatsCounter
//
//  Created by Наташа on 17.10.16.
//  Copyright © 2016 nborzenko. All rights reserved.
//

import UIKit
import SwiftCharts

class StatisticsViewController: UIViewController {

    @IBOutlet weak var chartView: UIView!
    var chartObject: Chart?
    var previousChartBounds = CGRect.zero
    var fromNow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(drawChart), name: Notification.Name("needRedrawChart"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if chartView.bounds != previousChartBounds {
            previousChartBounds = chartView.bounds
            drawChart()
        }
    }
    
    @IBAction func getPreviousPage(_ sender: AnyObject) {
        fromNow -= 1
        drawChart()
    }
    
    @IBAction func getNextPage(_ sender: AnyObject) {
        fromNow += 1
        drawChart()
    }
    
    func drawChart() {
        chartObject?.view.removeFromSuperview()
        chartObject = nil
        
        let chartSettings = ChartSettings()
        chartSettings.leading = 0
        chartSettings.top = 10
        chartSettings.trailing = 30
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 10
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 0
        chartSettings.axisStrokeWidth = 1
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        
        let labelSettings = ChartLabelSettings(fontColor: UIColor.white)
        let dateLabelSettings = ChartLabelSettings(fontColor: UIColor.white, rotation: -45)
        
        var xValues = [ChartAxisValueString("", order: 0)]
        let zero = ChartAxisValueDouble(0)
        var barModel = [ChartBarModel]()
        let days = DayManager.sharedInstance.getTenDays(fromNow: fromNow)

        for day in days {
            xValues.append(ChartAxisValueString(day.date, order: day.order, labelSettings: dateLabelSettings))
            barModel.append(ChartBarModel(constant: ChartAxisValueDouble(day.order), axisValue1: zero, axisValue2: ChartAxisValueDouble(day.count), bgColor: day.color))
        }
        xValues.append(ChartAxisValueString("", order: 11))
        
        let yValues = stride(from: 0, through: DayManager.sharedInstance.maxSquatsCount, by: 5).map {ChartAxisValueDouble($0, labelSettings: labelSettings)}
        
        let xModel = ChartAxisModel(axisValues: xValues, lineColor: UIColor.white, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, lineColor: UIColor.white, axisTitleLabel: ChartAxisLabel(text: "", settings: labelSettings.copy(rotation: -90)))
        
        let chartFrame = chartView.bounds
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let guidelinesLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.white, linesWidth: 0.5, dotWidth: 0.5)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: guidelinesLayerSettings)
        
        let barsLayer = ChartBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, bars: barModel, horizontal: false, barWidth: 15, animDuration: 0.5)
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                coordsSpace.xAxis,
                coordsSpace.yAxis,
                guidelinesLayer,
                barsLayer
            ]
        )
        
        chartView.addSubview(chart.view)
        chartObject = chart
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

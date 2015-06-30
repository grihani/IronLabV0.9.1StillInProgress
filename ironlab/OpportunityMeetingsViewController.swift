//
//  OpportunityMeetingsViewController.swift
//  IronLab
//
//  Created by Formation iOS on 10/06/2015.
//  Copyright (c) 2015 Formation iOS. All rights reserved.
//

//import UIKit
//import Charts
//
//class OpportunityMeetingsViewController: UIViewController, ChartViewDelegate {
//    
//    @IBOutlet weak var graphBarChartView: BarChartView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //Récupère l'axe X
//        var xAxis: ChartXAxis = graphBarChartView.xAxis
//        xAxis.drawGridLinesEnabled = false
//        xAxis.spaceBetweenLabels = 2
//        //Récupère l'axe Y gauche
//        var leftAxis: ChartYAxis = graphBarChartView.leftAxis
//        leftAxis.labelCount = 8;
//        leftAxis.drawGridLinesEnabled = false
//        leftAxis.valueFormatter = NSNumberFormatter()
//        leftAxis.valueFormatter!.maximumFractionDigits = 1;
//        leftAxis.spaceTop = 0.15;
//        //Récupère l'axe Y droit
//        var rightAxis: ChartYAxis = graphBarChartView.rightAxis
//        rightAxis.enabled = false
//        //Données abscisses
//        var xVals: [String] = ["J","F","M","A","M","J","J","A","S","O","N","D"]
//        //Données ordonnées
//        var yVals: [BarChartDataEntry] = []
//        for i in 0..<12 {
//            var val: Double = Double(random())
//            yVals.append(BarChartDataEntry(value: val, xIndex: i))
//        }
//        var set1: BarChartDataSet = BarChartDataSet(yVals: yVals, label: "DataSet")
//        set1.barSpace = 0.35
//        var dataSets: [BarChartDataSet] = []
//        dataSets.append(set1)
//        var data: BarChartData = BarChartData(xVals: xVals, dataSet: dataSets[0])
//        graphBarChartView.data = data
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//}
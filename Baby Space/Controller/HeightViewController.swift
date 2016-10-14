//
//  HeightViewController.swift
//  WXT_Parents
//
//  Created by zhang on 16/6/1.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import SwiftCharts
import Alamofire
import YYWebImage
import XWSwiftRefresh
import MBProgressHUD
class HeightViewController: UIViewController, HisHeightViewDelegate, UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var heightTextFiled: UITextField!    
    
    private var chart: Chart?
    private var avrHeightChart:Chart?
    var heightView = UIView()
    let table = UITableView()
    
    var chartView:HisHeightView?
    
    var str = String()
    
    var dataSource = sta_weiInfomationList()

    override func viewWillAppear(animated: Bool) {
        self.GETData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        
        self.title = "宝宝身高记录"
        self.view.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        
        
        self.createChartView()
        self.createBeizhu()
        self.createTable()
        
    }
    
    //  获取数据
    func GETData(){
        //  http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetChange_sta_wei&stuid=599
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let stuid = userDefaults.valueForKey("chid")
        
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=GetChange_stature"
        let pmara = ["stuid":stuid]
        
        GetName(url, pmara: (pmara as? [String:AnyObject])!)
        
    }
    func GetName(url:String,pmara:NSDictionary){
        Alamofire.request(.GET, url, parameters: pmara as? [String:AnyObject]).response { request, response, json, error in
            //  进行数据的操作
            if(error != nil){
                print(111)
                print("request是")
                print(request!)
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = Http(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    
                    messageHUD(self.view, messageData: status.errorData!)
                    
                }
                if(status.status == "success"){
                    //  获取数据成功
                    //  得到数据源
                    //   sta_weiInfomation(status.data!)  对里面的数据进行转型
                    self.dataSource = sta_weiInfomationList(status.data!)
                    print(self.dataSource)
                    let nowDate = NSDate()
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy.MM.dd"
                    let dateString = formatter.stringFromDate(nowDate)
                    print(dateString)
                    if self.dataSource.objectlist.count != 0{
                        if dateString != self.dataSource.objectlist[0].log_date {
                            self.createPick()
                        }
                    }else{
                        self.createPick()
                    }
                    
                    self.table.reloadData()
                    
//                    print(self.dataSource.objectlist[0].log_date)
                }
            }
        }
        
    }
    
    //    画图
    func createChartView(){
        heightView = UIView(frame: CGRectMake(10,10,WIDTH-20,200))
        heightView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(heightView)
        
        //        创建折线图
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        let chartPoints = [(0, 0), (0.5, 30), (1, 50), (1.5, 75), (2, 80), (2.5, 100), (3, 110)].map{ChartPoint(x: ChartAxisValueDouble($0.0), y: ChartAxisValueDouble($0.1))}
        let avrHeight = [(0, 0), (0.5, 34), (1, 45), (1.5, 70), (2, 85), (2.5, 90), (3, 100)].map{ChartPoint(x: ChartAxisValueDouble($0.0), y: ChartAxisValueDouble($0.1))}
        let xValues = Array(0.stride(through: 3, by: 0.5)).map {ChartAxisValueDouble($0, labelSettings: labelSettings)}
        let yValues = Array(0.stride(through: 120, by: 15)).map {ChartAxisValueDouble($0, labelSettings: labelSettings)}
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "年龄", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "身高", settings: labelSettings))
        
        let chartSettings = ExamplesDefaults.chartSettings
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: CGRectMake(1, 1, 300, 200), xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        // create layer with line
        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor(red: 122.0/255.0, green: 186.0/255.0, blue: 58.0/255.0, alpha: 1), lineWidth: 1, animDuration: 0.7, animDelay: 0)
        let avrlineModel = ChartLineModel(chartPoints: avrHeight, lineColor: UIColor(red: 253.0/255.0, green: 133.0/255.0, blue: 9.0/255.0, alpha: 1), lineWidth: 1, animDuration: 0.7, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
        let avrChartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [avrlineModel])
        
        let circleViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            let circleView = ChartPointEllipseView(center: chartPointModel.screenLoc, diameter: 6)
            circleView.animDuration = 0.5
            circleView.fillColor = UIColor.redColor()
            return circleView
        }
        let chartPointsCircleLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints, viewGenerator: circleViewGenerator, displayDelay: 0, delayBetweenItems: 0.05)
        let avrChartPointsCircleLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: avrHeight, viewGenerator: circleViewGenerator, displayDelay: 0, delayBetweenItems: 0.05)
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth, dotWidth: 1.0, dotSpacing: 1.0)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        let chart = Chart(
            frame: CGRectMake(0, 0, 300, 200),
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                chartPointsLineLayer,
                chartPointsCircleLayer,
                
                xAxis,
                yAxis,
                guidelinesLayer,
                avrChartPointsLineLayer,
                avrChartPointsCircleLayer
            ]
        )
        self.heightView.addSubview(chart.view)
        self.chart = chart
    }
    //    备注
    func createBeizhu(){
        let v = UIView(frame: CGRectMake(0,200,WIDTH,50))
        v.backgroundColor = RGBA(242.0, g: 242.0, b: 242.0, a: 1)
        self.view.addSubview(v)
        
        let imageV1 = UIImageView(frame: CGRectMake(10, 15, 20, 20))
        imageV1.backgroundColor = UIColor(red: 122.0/255.0, green: 186.0/255.0, blue: 58.0/255.0, alpha: 1)
        imageV1.layer.cornerRadius = 10.0
        v.addSubview(imageV1)
        
        let lbl1 = UILabel(frame: CGRectMake(40,15,100,20))
        lbl1.text = "宝宝身高曲线"
        lbl1.font = UIFont.systemFontOfSize(14.0)
        lbl1.textColor = RGBA(122.0, g: 122.0, b: 122.0, a: 1)
        v.addSubview(lbl1)
        
        let imageV2 = UIImageView(frame: CGRectMake(150, 15, 20, 20))
        imageV2.backgroundColor = UIColor(red: 253.0/255.0, green: 133.0/255.0, blue: 9.0/255.0, alpha: 1)
        imageV2.layer.cornerRadius = 10.0
        v.addSubview(imageV2)
        
        let lbl2 = UILabel(frame: CGRectMake(180,15,150,20))
        lbl2.text = "班级平均身高曲线"
        lbl2.font = UIFont.systemFontOfSize(14.0)
        lbl2.textColor = RGBA(122.0, g: 122.0, b: 122.0, a: 1)
        v.addSubview(lbl2)
    }
    //    创建表
    func createTable(){
        table.frame = CGRectMake(0, 250, WIDTH, HEIGHT-64-250)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
//        table.registerNib(UINib.init(nibName: "HeightTableViewCell", bundle: nil), forCellReuseIdentifier: "HeightCellID")
    }
    //    分区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //    行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.objectlist.count
    }
    //    行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    //    单元格
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: String(indexPath.row))
        cell.selectionStyle = .None
        
        let model = self.dataSource.objectlist[indexPath.row]
        let tizhong = UILabel()
        tizhong.frame = CGRectMake(10, 15, 40, 30)
        tizhong.text = "身高"
        cell.contentView.addSubview(tizhong)
        
        let weigt = UILabel()
        weigt.frame = CGRectMake(60, 15, 60, 30)
        weigt.text = model.stature! + "cm"
        cell.contentView.addSubview(weigt)
        
        let time = UILabel()
        time.frame = CGRectMake(WIDTH - 130, 15, 120, 30)
        time.text = model.log_date
        time.textColor = UIColor.lightGrayColor()
        time.textAlignment = NSTextAlignment.Right
        cell.contentView.addSubview(time)

        return cell
    }

    func createPick(){
        chartView = HisHeightView()
        chartView?.frame = CGRectMake(0, HEIGHT - 345, WIDTH, 280)
        chartView?.delegate = self
        self.view.addSubview(chartView!)
    }

    func hisHeightView(alertView: HisHeightView!) {
        
        self.str = String(alertView.Taketime)
        self.GetDate()
        self.chartView?.removeFromSuperview()
    }
    
    func hisHeightVie(alertView: HisHeightView!) {
        self.chartView?.removeFromSuperview()
    }

    
    
//    记录身高
    func GetDate(){
        //http://wxt.xiaocool.net/index.php?g=apps&m=index&a=RecordHeight&stuid=599&stature=134

        //下面两句代码是从缓存中取出userid（入参）值
        let defalutid = NSUserDefaults.standardUserDefaults()
        let sid = defalutid.stringForKey("chid")
        let url = "http://wxt.xiaocool.net/index.php?g=apps&m=index&a=RecordHeight"

        let param = [
            "stuid":sid!,
            "stature":self.str
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
            }
            else{
                print("request是")
                print(request!)
                print("====================")
                let status = Http(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = "今天已经记录"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    self.GETData()
                    self.table.reloadData()
                    self.chartView?.removeFromSuperview()
                }
            }
        }
    }
}

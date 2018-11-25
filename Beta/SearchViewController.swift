//
//  SearchViewController.swift
//  Beta
//
//  Created by Andy Alleyne on 11/22/18.
//  Copyright © 2018 AlleyneVentures. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON
import WebKit
import ScrollableGraphView

class SearchViewController: UIViewController, ScrollableGraphViewDataSource{
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch (plot.identifier) {
        case "line":
            return Double(linePlotData[pointIndex])
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(xCoorData)"
    }
    
    func numberOfPoints() -> Int {
        return xCoorData.count
    }
    
    var linePlotData = [Int]()
    var numberOfDataPointsInGraph = 18
    var pointIndex = 1
    var xCoorData = [String]()

    @IBOutlet weak var SymbolImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var peLabel: UILabel!
    @IBOutlet weak var MktCap: UILabel!
    
    @IBOutlet weak var webViewOutlet: WKWebView!
    
    
    let apiUrl = "https://api.iextrading.com/1.0/stock/"
    let logo = "https://api.iextrading.com/1.0/stock/aapl/logo?types=quote,news,chart&range=1m&last=1"
    let market = "https://api.iextrading.com/1.0/market/?"
    
    //setup the graph view
    
    var searchName = ""
    var data = StockData()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(searchName)
        
       
        
        setUpURL(userData: searchName)
        updateUI()
        // Do any additional setup after loading the view.
    }
    

    func createGraphs(dataToPlot : [Int], numberOfPointsToPlot : Int, jsonData : JSON) {
        let graphView = ScrollableGraphView(frame: CGRect(x: 17, y: 300, width: 350, height: 350), dataSource: self)
        let linePlot = LinePlot(identifier: "line")
        let referenceLines = ReferenceLines()
        
        
        graphView.addPlot(plot: linePlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        //custom settings
        graphView.shouldAdaptRange = true
        graphView.shouldAnimateOnStartup = true
        graphView.backgroundFillColor = UIColor.gray
        
        linePlot.lineWidth = 1
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
       
        //look for rbg information from hex
        
        // linePlot.fillGradientStartColor = UIColor.#colorLiteral(red: 0.286239475, green: 0.2862946987, blue: 0.2862360179, alpha: 1)
       // linePlot.fillGradientEndColor = UIColor.#colorLiteral(red: 0.1960526407, green: 0.1960932612, blue: 0.1960500479, alpha: 1)
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        
        
        
        
        //edit Json for chart data
        
        for eachItem in jsonData["chart"].arrayValue{
            
            print(eachItem["label"].stringValue)
            print(eachItem["close"].stringValue)
            
            xCoorData.append(eachItem["label"].stringValue)
            linePlotData.append(eachItem["close"].int!)
            
            
        }
        
        view.addSubview(graphView)
    }
    




    func setUpURL(userData : String){
        
        let apiParams = "/batch?types=quote,logo,news,chart&range=1m&last=1"
            
            SVProgressHUD.show()
            let finalURL = apiUrl + userData + apiParams
            getStockData(url: finalURL)
        
    }
    
    
   
    
    
    func getStockData(url: String) {
        
        Alamofire.request(url, method: .get) //parameters can be placed after the get
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    let stockData : JSON = JSON(response.result.value!)
                    self.processStockData(jsonData: stockData)
                    self.createGraphs(dataToPlot: self.linePlotData, numberOfPointsToPlot: 17, jsonData: stockData)
                //    print(stockData)
                    SVProgressHUD.dismiss()
                }else{
                    
                    print("somthing went wrong: \(String(describing: response.result.error))")
                    
                }
        }
        
    }
    
    
    
    
    
    
    func processStockData(jsonData : JSON){
        
       // if jsonData["quote"]["companyName"].string != nil {
           // data.companyName = jsonData["quote"]["companyName"].string!
           // data.currentPrice = jsonData["quote"]["latestPrice"].string!
           // data.logo = jsonData["quote"]["logo"].string!
        
//print(<#T##items: Any...##Any#>)
      //  data.companyName = jsonData[1]["quote"]["companyName"].string!
        
      //  print(jsonData)
        
        //print(jsonData)
        data.companyName = jsonData["quote"]["companyName"].string!
        
        
        if let editedData = jsonData["quote"]["high"].string{
            
            print(editedData)
            
        }else if let editData = jsonData[]["quote"].string{
            
            print(editData)
        }
    
        
        
        
    }
    
    
    
    func updateUI(){
        
        //SymbolImageView.image = UIImage(contentsOfFile: data.logo)
        companyNameLabel.text = data.companyName
        priceLabel.text = "$\(data.currentPrice)"
        changeLabel.text = data.change
        symbolLabel.text = data.stockSymbol
        highLabel.text = data.high
        openLabel.text = data.open
        lowLabel.text = data.low
        volumeLabel.text = data.volume
        peLabel.text = data.PE
        MktCap.text = data.marketCap
        
      //  webViewOutlet.url(URL(logo))
        
    }
    
    
    //MARK: scrollable graph view
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

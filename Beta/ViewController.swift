//
//  ViewController.swift
//  Beta
//
//  Created by Andy Alleyne on 11/22/18.
//  Copyright © 2018 AlleyneVentures. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController {

    
    @IBOutlet weak var searchFieldTextField: UITextField!
    @IBOutlet weak var marketOne: UILabel!
    @IBOutlet weak var marketTwo: UILabel!
    @IBOutlet weak var marketThree: UILabel!
    @IBOutlet weak var marketOneVolume: UILabel!
    @IBOutlet weak var marketTwoVolume: UILabel!
    @IBOutlet weak var marketThreeVol: UILabel!
    @IBOutlet weak var marketChangeOne: UILabel!
    @IBOutlet weak var marketChangetwo: UILabel!
    @IBOutlet weak var marketChangeThree: UILabel!
    
    var marketVolumeTracker = [String]()
    var marketVenueNameTracker = [String]()
    
    let apiUrl = "https://api.iextrading.com/1.0/stock/"
    let logo = "https://api.iextrading.com/1.0/stock/aapl/logo?types=quote,news,chart&range=1m&last=1"
    let market = "https://api.iextrading.com/1.0/market/?"
    
    var data = StockData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      //  updateUI()
        
    }
    
    func setupMarketInfo(){
        
        let url = "https://api.iextrading.com/1.0/market"
        
        Alamofire.request(url, method: .get) //parameters can be placed after the get
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    let returnedStockData : JSON = JSON(response.result.value!)
                    
                    self.procesMarketData(jsonData: returnedStockData)
                    
                  //  self.processStockData(jsonData: returnedStockData)
                    
                //    self.performSegue(withIdentifier: "goToStockDetailsPage", sender: self)
                    
                    SVProgressHUD.dismiss()
                }else{
                    
                    print("somthing went wrong: \(String(describing: response.result.error))")
                    
                }
        }
        
        
    }
    
    
    func updateUI(){
        let i = 0
      /*
        marketOne.text = marketVenueNameTracker[0]
        marketOneVolume.text = marketVolumeTracker[0]
        
        marketTwo.text = marketVenueNameTracker[4]
        marketTwoVolume.text = marketVolumeTracker[4]
        
        marketThree.text = marketVenueNameTracker[8]
        marketThreeVol.text = marketVolumeTracker[8]
 */
 }
    
    func procesMarketData(jsonData : JSON){
        
        for eachItem in jsonData[].arrayValue{
         marketVenueNameTracker.append(eachItem["venueName"].stringValue)
         marketVolumeTracker.append(eachItem["volume"].stringValue)
        }
    }
    

    @IBAction func searchButton(_ sender: UIButton) {
        
        let apiParams = "/batch?types=quote,logo"
        
        
        if let userProvidedValue = searchFieldTextField.text{
            
            SVProgressHUD.show()
            let finalURL = apiUrl + userProvidedValue + apiParams
            getStockData(url: finalURL)
            
            
            
        }else {
            print("enter a stock symbol or company name")
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStockDetailsPage" {
            
            let nextViewController = segue.destination as! SearchViewController
            
            if let stockSearch = searchFieldTextField.text {
            
            nextViewController.searchName = stockSearch
            nextViewController.data = data
            
            }
        }
    }
    
    func getStockData(url: String) {
        
        Alamofire.request(url, method: .get) //parameters can be placed after the get
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    let returnedStockData : JSON = JSON(response.result.value!)
                    
                    
                
                    
                    
                    self.processStockData(jsonData: returnedStockData)
                    
                    self.performSegue(withIdentifier: "goToStockDetailsPage", sender: self)
                    
                    SVProgressHUD.dismiss()
                }else{
                    
                    print("somthing went wrong: \(String(describing: response.result.error))")
                    
                }
        }
                
    }
    
    
    func processStockData(jsonData : JSON){
        
       // if jsonData["quote"]["companyName"].string != nil {
        //data.companyName = jsonData["quote"]["companyName"].string!
         //   data.currentPrice = jsonData["quote"]["close"].string!
         //   data.logo = jsonData["quote"]["logo"].string!
        //}
        
       // let json = JSON(data: jsonData)
      //  if let currentPrice = json[0]["quote"]["latestPrice"].string {
      //      print("the current price is: \(currentPrice)")
      //  }
        
        
        //if let companyName
        
        if let currentPrice = jsonData[1]["quote"]["latestPrice"].string {
            print("the current price is: \(currentPrice)")
        }
        
        data.companyName = jsonData["quote"]["companyName"].stringValue
        data.currentPrice = jsonData["quote"]["previousClose"].stringValue //figure out latest price issue
        data.high = jsonData["quote"]["high"].stringValue
        data.logo = jsonData["logo"]["url"].stringValue
        data.low = jsonData["quote"]["low"].stringValue
        data.change = jsonData["quote"]["change"].stringValue
        data.open = jsonData["quote"]["open"].stringValue
        data.PE = jsonData["quote"]["peRatio"].stringValue
        data.volume = jsonData["quote"]["vol"].stringValue
        data.marketCap = jsonData["quote"]["companyName"].stringValue
        
        //print(data.companyName)
        
    }
    
}


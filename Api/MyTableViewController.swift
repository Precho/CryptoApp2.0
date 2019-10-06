//
//  ViewController.swift
//  Api
//
//  Created by Preszko on 29.09.2019.
//  Copyright © 2019 Preszko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class MyTableViewController: UITableViewController {
   
    @IBOutlet var reloadButton: UIButton!
    
        let cryptoImageArray = ["btc","eth","ltc","xrp","eos"]
        var  val1 : Double = 0
        var priceArray = [Double]()
        let api_key = "7c20af7a59852d33c46c5d760fdc954e"
        let url = "https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH,LTC,XRP,BCH,EOS&tsyms=PLN"
    override func viewDidLoad() {
        reloadButton.isHidden = true
        super.viewDidLoad()
        request()
//        Alamofire.request(url).response { response in
//            debugPrint(response)
   
    }
    
    func parseJson(json : JSON) {
        
        priceArray.append(json["BTC"]["PLN"].doubleValue) // 1 BTC
        priceArray.append(json["ETH"]["PLN"].doubleValue) // 2 ETH
        priceArray.append(json["LTC"]["PLN"].doubleValue) // 3 LTC
        priceArray.append(json["XRP"]["PLN"].doubleValue)// 4 XRP
//        priceArray.append(json["BCH"]["PLN"].doubleValue)// 5 BITCOIN CASH
        priceArray.append(json["EOS"]["PLN"].doubleValue) // 6 EOS
        
//        val1 = json["id"].intValue
//        val2 = json["title"].stringValue
//        print(tempResult,tempResultString)
//        let val1 = json["name"].stringValue
//
//        let val2 = json["weather"][0]["id"].intValue
     print(priceArray)
        tableView.reloadData()
       SVProgressHUD.dismiss(withDelay: 1)
        reloadButton.isHidden = false
        
    }
    

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceArray.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        cell.textLabel?.text = String(priceArray[indexPath.row])
        cell.imageView?.image = UIImage(named: cryptoImageArray[indexPath.row])
        
        return cell
        
    }
    func request() {
        SVProgressHUD.show()
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Sucess!")
                    SVProgressHUD.showSuccess(withStatus: "Sucess!")
                    let priceJSON: JSON = JSON(response.result.value!)
                    
                    print(priceJSON)
                    self.parseJson(json: priceJSON)
                } else {
                    
                    print("Error: \(String(describing: response.result.error))")
                    
                }
        }
    }
    
    @IBAction func ReloadData(_ sender: Any) {
        priceArray.removeAll()
        request()
    }
}


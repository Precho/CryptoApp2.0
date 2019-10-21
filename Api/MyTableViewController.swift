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
import SwipeCellKit
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
    // SwipeCellKIT DELEGATE
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = String(priceArray[indexPath.row])
        cell.imageView?.image = UIImage(named: cryptoImageArray[indexPath.row])
        
        
        return cell
        
    }
    // Row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
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
    // refresh by swipe
    @IBAction func refresh(_ sender: UIRefreshControl) {
        
        priceArray.removeAll()
        request()
        sender.endRefreshing()
        
    }
    @IBAction func ReloadData(_ sender: Any) {
        priceArray.removeAll()
        request()
    }
}

// Swipe delegejttt
extension MyTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.priceArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-ic")
        
        return [deleteAction]
    }
    
}

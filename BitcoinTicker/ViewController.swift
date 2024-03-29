//
//  ViewController.swift
//  Bitcoin Price Tracker
//  Kordell M. Schrock
//
import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
   
   
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbolArray = ["$", "R$", "can$", "¥", "€","£", "HK$", "Rp", "₪", "₹",  "¥", "Mex$", "kr", "$", "zł", "lei", "₽", "kr", "S$", "$", "R" ]
    
    var currentCurrency = ""
    //used to keep the current currency for the selected currency
    var finalURL = ""
    

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self

        super.viewDidLoad()
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return currencyArray.count
       }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        currentCurrency = currencySymbolArray[row]
        getBitcoin(url: finalURL)
    }

    
    
    
//    
//     Networking
//    /***************************************************************/
    
    func getBitcoin(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the Bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
//
//    
//    
//    
//    
//     JSON Parsing
//    /***************************************************************/
//    
    func updateBitcoinData(json : JSON) {
        
        if let bitcoinResult = json["ask"].double {
        
            bitcoinPriceLabel.text = currentCurrency + String(bitcoinResult)
            //gets the bitcoin price from the json data
        }
        else{
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
    




}


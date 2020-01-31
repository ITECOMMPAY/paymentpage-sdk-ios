//
//  ViewController.swift
//  IntegrationExampleSwift
//
//  Created by Deniss Kaibagarovs on 07/02/2019.
//  Copyright © 2019 Ecommpay. All rights reserved.
//

import UIKit
import ecommpaySDK

class ViewController: UIViewController {
    
    let secret = "your_secret"
    let project_id = 10 // your project id
    
    let ecompaySDK = EcommpaySDK()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create payment info with product information
        let paymentInfo = getPaymentInfoAllParams() // getPaymentInfoOnlyRequiredParams
        
        #warning("Signature should be generated on your server and delivered to your app")
        let signature = getSignature(stringToSign: paymentInfo.getParamsForSignature())
        
        // Sign payment info
        paymentInfo.setSignature(value: signature)
        
        ecompaySDK.presentPayment(at: self, paymentInfo: paymentInfo) { (result) in
            print("ecommpaySDK finisehd with status \(result.status.rawValue)")
            if let error = result.error { // if error occurred
                print("Error: \(error.localizedDescription)")
            }
            if let token = result.token { // if tokenize action
                print("Token: \(token)")
            }
        }
    }
    
    //MARK: - Payment Info
    func getPaymentInfoOnlyRequiredParams() -> PaymentInfo {
        return PaymentInfo(projectID: project_id, // project ID that is assigned to you
                           paymentID: "internal_payment_id_1", // payment ID to identify payment in your system
                           paymentAmount: 1999, // 19.99
                           paymentCurrency: "USD")
    }
    
    func getPaymentInfoAllParams() -> PaymentInfo {
        return PaymentInfo(projectID: project_id,
                           paymentID: "internal_payment_id_1",
                           paymentAmount: 1999,
                           paymentCurrency: "USD",
                           paymentDescription: "T-shirt with dog print",
                           customerID: "10", // unique ID assigned to your customer
                           regionCode: "")
    }
    
    //MARK: - Signature
    func getSignature(stringToSign:String) -> String {
        return Utils.signature(paramsToSign: stringToSign, secret: secret)
    }
    
    //MARK: - Additionals
    func setDMSPayment(paymentInfo:PaymentInfo) {
        paymentInfo.setAction(action: .Auth)
    }
    
    func setActionTokenize(paymentInfo:PaymentInfo) {
        paymentInfo.setAction(action: .Tokenize)
    }
    
    func setActionVerify(paymentInfo:PaymentInfo) {
        paymentInfo.setAction(action: .Verify)
    }
    
    func setToken(paymentInfo:PaymentInfo) {
        paymentInfo.setToken(value: "token")
    }
    
    func setReceiptData(paymentInfo:PaymentInfo) {
        paymentInfo.setReceiptData(value: "receipt data")
    }
    
    func setRecurrent(paymentInfo:PaymentInfo) {
        let recurrentInfo = RecurrentInfo(type: .Autopayment,
                                          expiryDay: "20",
                                          expiryMonth: "10",
                                          expiryYear: "2030",
                                          period: .Month,
                                          time: "12:00:00",
                                          startDate: "12-02-2020",
                                          scheduledPaymentID: "your_recurrent_id")
        // Additional options if needed
//        recurrentInfo.setAmount(amount: 1000)
//        recurrentInfo.setSchedule(schedule: [
//            RecurrentInfoSchedule(date: "10-10-2020", amount: 1200),
//            RecurrentInfoSchedule(date: "10-11-2020", amount: 1000),
//            ])
        
        paymentInfo.setRecurrent(recurrent: recurrentInfo)
    }
    
    func setKnownAdditionalFields(paymentInfo:PaymentInfo) {
        paymentInfo.setAdditionalFields(additionalFields: [
            AdditionalField(type: .customer_first_name, value: "Mark"),
            AdditionalField(type: .billing_country, value: "US")
            ])
    }
    
    //MARK: - Additionals
    func setDarkTheme() {
        let theme = ECPTheme.getDarkTheme()
        // Additional changes if needed
//        theme.backgroundColor = UIColor.green
//        theme.showDarkKeyboard = true
        ecompaySDK.setTheme(theme: theme)
    }
}


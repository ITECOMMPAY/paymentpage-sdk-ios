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
        
        // Present Checkout UI
        ecompaySDK.presentPayment(at: self, paymentInfo: paymentInfo) { (paymentStatus, error) in
            print("ecommpaySDK finisehd with status \(paymentStatus.rawValue)")
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
        paymentInfo.setCreditCardPaymentType(creditCardPaymentType: .Auth)
    }
    
    func setToken(paymentInfo:PaymentInfo) {
        paymentInfo.setToken(value: "token")
    }
    
    func setRecurrent(paymentInfo:PaymentInfo) {
        let recurrentInfo = RecurrentInfo(type: .Autopayment,
                                          expiryMonth: "10",
                                          expiryYear: "2030",
                                          period: .Month,
                                          time: "12:00:00",
                                          startDate: "12-02-2020",
                                          scheduledPaymentID: "your_recurrent_id")
        
        paymentInfo.setRecurrent(recurrent: recurrentInfo)
    }
}


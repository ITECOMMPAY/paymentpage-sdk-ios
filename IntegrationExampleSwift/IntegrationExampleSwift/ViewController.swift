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
    
    func setApplePayMerchantID(paymentInfo:PaymentInfo) {
        paymentInfo.setApplePayMerchantID(merchantID: "merchant.example.com")
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
    
    // MARK: - 3D Secure 2.0 parameters
    func setupThreeDSecureParams(paymentInfo: PaymentInfo) {
        let threeDSecureInfo = ThreeDSecureInfo()
         
        let threeDSecurePaymentInfo = ThreeDSecurePaymentInfo()
        let threeDSecureCustomerInfo = ThreeDSecureCustomerInfo()
         
        let giftCard = ThreeDSecureGiftCardInfo() // object with information about payment with prepaid card or gift card.
        giftCard.amount = 12345 // Amount of payment with prepaid or gift card denominated in minor currency units.
        giftCard.currency = "USD" //    Currency of payment with prepaid or gift card in the ISO 4217 alpha-3 format
        giftCard.count = 1 // Total number of individual prepaid or gift cards/codes used in purchase.
         
        threeDSecurePaymentInfo.challengeIndicator = "01" // This parameter indicates whether challenge flow is requested for this payment.
        threeDSecurePaymentInfo.challengeWindow = "01" // The dimensions of a window in which authentication page opens.
        threeDSecurePaymentInfo.preorderDate = "01-10-2020" // The date the preordered merchandise will be available.
        threeDSecurePaymentInfo.preorderPurchase = "01" // This parameter indicates whether cardholder is placing an order for merchandise with a future availability or release date.
        threeDSecurePaymentInfo.reorder = "01" // This parameter indicates whether the cardholder is reordering previously purchased merchandise.
        threeDSecurePaymentInfo.giftCard = giftCard // object with information about payment with prepaid card or gift card.
         
        let threeDSecureAccountInfo = ThreeDSecureAccountInfo() // object with account information on record with merchant
         
        threeDSecureAccountInfo.additional = "gamer12345" // Additional customer account information, for instance arbitrary customer ID.
        threeDSecureAccountInfo.ageIndicator = "01" // Number of days since the customer account was created.
        threeDSecureAccountInfo.date = "01-01-2020" // Account creation date.
        threeDSecureAccountInfo.changeIndicator = "01" // Number of days since last customer account update, not including password change or reset.
        threeDSecureAccountInfo.changeDate = "01-10-2019" // Last account change date except for password change or password reset.
        threeDSecureAccountInfo.passChangeIndicator = "01" // Number of days since the last password change or reset.
        threeDSecureAccountInfo.passChangeDate = "01-10-2020" // Last password change or password reset date.
        threeDSecureAccountInfo.purchaseNumber = 12 // Number of purchases with this cardholder account in the previous six months.
        threeDSecureAccountInfo.provisionAttempts = 16 // Number of attempts to add card details in customer account in the last 24 hours.
        threeDSecureAccountInfo.activityDay = 22 // Number of card payment attempts in the last 24 hours.
        threeDSecureAccountInfo.activityYear = 222 // Number of card payment attempts in the last 365 days.
        threeDSecureAccountInfo.paymentAgeIndicator = "01" // Number of days since the payment card details were saved in a customer account.
        threeDSecureAccountInfo.paymentAge = "01-10-2019" // Card record creation date.
        threeDSecureAccountInfo.suspiciousActivity = "01" // Suspicious activity detection result.
        threeDSecureAccountInfo.authMethod = "01" // Authentication type the customer used to log on to the account when placing the order.
        threeDSecureAccountInfo.authTime = "01-10-201913:12" // Account log on date and time.
        threeDSecureAccountInfo.authData = "login_0102" // Any additional log in information in free text.
         
        let threeDSecureShippingInfo = ThreeDSecureShippingInfo() // object that contains shipment details
         
        threeDSecureShippingInfo.type = "01" // Shipment indicator.
        threeDSecureShippingInfo.deliveryTime = "01" // Shipment terms.
        threeDSecureShippingInfo.deliveryEmail = "test@gmail.com" // The email to ship purchased digital content, if the customer chooses email delivery.
        threeDSecureShippingInfo.addressUsageIndicator = "01" // Number of days since the first time usage of the shipping address.
        threeDSecureShippingInfo.addressUsage = "01-10-2019" // First shipping address usage date in the dd-mm-yyyy format.
        threeDSecureShippingInfo.city = "Moscow" // Shipping city.
        threeDSecureShippingInfo.country = "RU" // Shipping country in the ISO 3166-1 alpha-2 format
        threeDSecureShippingInfo.address = "Lenina street 12" // Shipping address.
        threeDSecureShippingInfo.postal = "109111" // Shipping postbox number.
        threeDSecureShippingInfo.regionCode = "MOW" // State, province, or region code in the ISO 3166-2 format.
        threeDSecureShippingInfo.nameIndicator = "01" // Shipment recipient flag.
         
        let threeDSecureMpiResultInfo = ThreeDSecureMpiResultInfo() // object that contains information about previous customer authentication
         
        threeDSecureMpiResultInfo.acsOperationId = "00000000-0005-5a5a-8000-016d3ea31d54" // The ID the issuer assigned to the previous customer operation and returned in the acs_operation_id parameter inside the callback with payment processing result.
        threeDSecureMpiResultInfo.authenticationFlow = "01" // The flow the issuer used to authenticate the cardholder in the previous operation and returned in the authentication_flow parameter of the callback with payment processing results.
        threeDSecureMpiResultInfo.authenticationTimestamp = "201812141050" // Date and time of the previous successful customer authentication as returned in the mpi_timestamp parameter inside the callback message with payment processing result.
         
        threeDSecureCustomerInfo.addressMatch = "Y" //The parameter indicates whether the customer billing address matches the address specified in the shipping object.
        threeDSecureCustomerInfo.homePhone = "79105211111" // Customer home phone number.
        threeDSecureCustomerInfo.workPhone = "73105219876" // Customer work phone number.
        threeDSecureCustomerInfo.billingRegionCode = "ABC" // State, province, or region code in the ISO 3166-2 format. Example: SPE for Saint Petersburg, Russia.
         
        threeDSecureCustomerInfo.accountInfo = threeDSecureAccountInfo
        threeDSecureCustomerInfo.shippingInfo = threeDSecureShippingInfo
        threeDSecureCustomerInfo.mpiResultInfo = threeDSecureMpiResultInfo
         
        threeDSecureInfo.threeDSecurePaymentInfo = threeDSecurePaymentInfo
        threeDSecureInfo.threeDSecureCustomerInfo = threeDSecureCustomerInfo
        paymentInfo.setSecureInfo(secureInfo: threeDSecureInfo)
    }
}


[![CocoaPods](https://img.shields.io/cocoapods/v/Paymentpage-sdk-ios.svg)](https://github.com/ITECOMMPAY/paymentpage-sdk-ios)
[![Badge w/ Platform](https://img.shields.io/cocoapods/p/Paymentpage-sdk-ios.svg?style=flat)](https://github.com/ITECOMMPAY/paymentpage-sdk-ios)

ECommPay SDK for iOS
===========

SDK for iOS is a software development kit for fast integration of the ECommPay payment solutions right in your mobile app for iOS. With SDK for iOS, you can quickly build and offer your customers a fast checkout experience from in your iOS app. In this section you will find information about using SDK for iOS as well as Swift and Objective-C code samples.

General information about SDK for iOS
-------------------------------------

### What can I do with SDK for iOS?

SDK for iOS allows you to perform purchases by using payment cards and alternative payment methods. You may perform one-step and two-step purchases and COF purchases using payment cards, as well as card verification.

### What's inside?

SDK for iOS contains the library which is used for developing applications and running them on Apple devices, and code samples in Swift and Objective-C.

### Payment workflow

After you integrate an SDK for iOS library into your iOS app, checkout payment is processed as follows:

1.  Your client app creates an instance of payment object with all the necessary checkout details.
2.  On the basis of the payment object parameters, the back end part of you app generates the signature for checkout request.
3.  You call a special method of the payment object to have the client app initiate a checkout request and send it to the ECommPay payment platform.
4.  The ECommPay payment platform processes the checkout request and performs the payment.
5.  The payment platform sends the payment processing results to the client app.
6.  The payment platform sends a callback with the payment processing results to the callback URL you specified.

Adding library in your project
------------------------------

### Importing libraries in Swift

Listed below are the instructions on how to import a ECommPay library into your iOS app.

1.  Copy the `ecommpaySDK.xcframework` file in the project folder of you iOS app.
2.  Add the library into your project. When using Xcode 12, you need to do the following:
    1.  Open the target of your project.
    2.  Select General > Embedded Binaries.
    3.  Click +.
    4.  Click Add Other.
    5.  Select the `ecommpaySDK.xcframework` file and click Add.
3.  Add key NSCameraUsageDescription with value `permission is needed in order to scan card` to the Info.plist file.
4.  If your iOS app does not use user location information, add the NSLocationWhenInUseUsageDescription key with the `fraud prevention` value in the Info.plist file.
    
    The ECommPay libraries code does not request user location, if the request is not initiated by the host app, but App Store requires that the NSLocationWhenInUseUsageDescription key value is not empty.
    
    If your iOS app requests user location information, you can skip this step.
    
5.  If the iOS app does not have permission to save data on the mobile device, add Privacy - Photo Library Usage Description and Privacy - Photo Library Additions Usage Description keys with values to the Info.plist file. The values specified are shown to the customer in the permission request message.

### Importing libraries in Objective-C

Listed below are the instructions on how to import a ECommPay library into your iOS app.

1.  Copy the `ecommpaySDK.xcframework` file in the project folder of you iOS app.
2.  Add the library into your project. When using Xcode 12, you need to do the following:
    1.  Open the target of your project.
    2.  Select General > Embedded Binaries.
    3.  Click +.
    4.  Click Add Other.
    5.  Select the `ecommpaySDK.xcframework` file and click Add.
    6.  Select Build Settings.
    7.  Set Always embed swift embedded libraries to Yes.
3.  Add key NSCameraUsageDescription with value `permission is needed in order to scan card` to the Info.plist file.
4.  If your iOS app does not use user location information, add the NSLocationWhenInUseUsageDescription key with the `fraud prevention` value in the Info.plist file.
    
    The ECommPay libraries code does not request user location, if the request is not initiated by the host app, but App Store requires that the NSLocationWhenInUseUsageDescription key value is not empty.
    
    If your iOS app requests user location information, you can skip this step.
    
5.  If the iOS app does not have permission to save data on the mobile device, add Privacy - Photo Library Usage Description and Privacy - Photo Library Additions Usage Description keys with values to the Info.plist file. The values specified are shown to the customer in the permission request message.

### Importing libraries via CocoaPods

Listed below are the instructions on how to import the libraries via CocoaPods.

1.  Open the Podfile file and add the following strings:
    
        target 'App' do
          # Pods for App
          pod 'Paymentpage-sdk-ios'
        end
    
2.  Add key NSCameraUsageDescription with value `permission is needed in order to scan card` to the Info.plist file.
3.  If your iOS app does not use user location information, add the NSLocationWhenInUseUsageDescription key with the `fraud prevention` value in the Info.plist file.
    
    The ECommPay libraries code does not request user location, if the request is not initiated by the host app, but App Store requires that the NSLocationWhenInUseUsageDescription key value is not empty.
    
    If your iOS app requests user location information, you can skip this step.
    
4.  If the iOS app does not have permission to save data on the mobile device, add Privacy - Photo Library Usage Description and Privacy - Photo Library Additions Usage Description keys with values to the Info.plist file. The values specified are shown to the customer in the permission request message.

Opening payment form
--------------------

This section contains samples of payment form invocation code in Swift and Objective-C.

### Opening payment form in Swift

To open payment form, do the following:

1.  Import the library:
    
        import ecommpaySDK
    
2.  Declare the reference to instance of `EcommpaySDK` class in you app (for example, inside the `viewDidLoad` method):
    
        let sdkFacade = EcommpaySDK()
    
3.  Create an object named `PaymentInfo` with all the required parameters and any number of optional parameters, for example:
    
        let paymentInfo = PaymentInfo(projectID: 10,
                                    paymentID: "internal_payment_id_1",
                                    paymentAmount: 1999,
                                    paymentCurrency: "USD",
                                    paymentDescription: "T-shirt with dog print",
                                    customerID: "10",
                                    regionCode: "US")
    
    Here are the required parameters:
    
    *   projectID—project (merchant) ID ECommPay assigned you
    *   paymentID—payment ID, must be unique within the project
    *   paymentAmount—payment amount in minor currency units
    *   paymentCurrency—payment currency code according to ISO-4217 alpha-3
    
    Here are the optional parameters:
    
    *   recurrentInfo—object with the details of COF purchase
    *   paymentDescription—payment description (this parameter is available not only to the merchant, but also to the customer; if paymentDescription is specified in the request, it is visible to the customer in the payment form (in the dialog box containing information about the payment); if this parameter is not specified in the request, it is not visible to the customer)
    *   customerID—customer ID
    *   regionCode—customer country
    *   token—card token
    *   action—action type (`Sale` (by default), `Auth`, `Tokenize`, or `Verify`)
    *   forcePaymentMethod—the identifier of the payment method which is opened to the customer without an option for the customer to select another payment method. The list of codes is provided in the [IDs of payment methods supported on Payment Page](en_PP__Paramaters_ForcePaymentMethod.html) section
    *   hideSavedWallets—hiding or displaying saved payment instruments in the payment form. Possible values:
        *   `true`—saved payment instruments are hidden, they are not displayed in the payment form
        *   `false`—saved payment instruments are displayed in the payment form
    *   hideScanningCards - hiding or displaying button to start card scanning flow
    *   ECommPayHostsScreenDisplayMode—object to manage display of the final page of the payment form and hide the final page if necessary. The following parameters can be passed in the object:
        
        *   `hide_success_final_page`—the final page with the message about the performed payment is not displayed in the payment form.
        *   `hide_decline_final_page`—the final page with the message about the declined payment is not displayed in the payment form.
        
        The following is an example of specifying the `hide_success_final_page` and `hide_decline_final_page` parameters in the request:
        
            // Init PaymentInfo class instance
             
            paymentInfo.addScreenDisplayMode(screenDisplayMode: .hideSuccessFinalPage)
                       .addScreenDisplayMode(screenDisplayMode: .hideDeclineFinalPage)
        
4.  Pack all the payment parameters into a string for signing:
    
    paymentInfo.getParamsForSignature();
    
5.  Send the string to your back end.
6.  Have your back end generate the signature on the basis of the string and your secret key.
7.  Add signature in your `PaymentInfo` object:
    
    paymentInfo.setSignature(value: signature)
    
8.  Open the payment form by using the following code:
    
        sdkFacade.presentPayment(at: self, paymentInfo: paymentInfo) { (result) in
           print("ECommPay SDK finished with status \\(result.status.rawValue)")
           if let error = result.error { // if error occurred
              print("Error: \\(error.localizedDescription)")
           }
           if let token = result.token { // if tokenize action
              print("Token: \\(token)")
           }
         }
        
    Before opening the payment form, the library check for any errors and opens the payment form only if no errors occur. Otherwise, the payment form is not opened and the presentPayment method returns the error code.
    

### Opening payment form in Objective-C

To open payment form, do the following:

1.  Import the library:
    
        #import <ecommpaySDK/ECommPayhostsSDK.h>
    
2.  Declare the EcommpaySDK library in you app (for example, inside the `viewDidLoad` method).
    
        EcommpaySDK *sdkFacade = [[EcommpaySDK alloc] init];
    
3.  Create an object named `PaymentInfo` with all the required parameters and any number of optional parameters, for example:
    
        PaymentInfo *paymentInfo = [[PaymentInfo alloc] initWithProjectID:10
                                    paymentID:@"internal_payment_id_1"
                                paymentAmount:1999
                              paymentCurrency:@"USD"
                           paymentDescription:@"T-shirt with dog print"
                                   customerID:@"10"
                                   regionCode:@"US"];
    
    Here are the required parameters:
    
    *   projectID—project (merchant) ID ECommPay assigned you
    *   paymentID—payment ID, must be unique within the project
    *   paymentAmount—payment amount in minor currency units
    *   paymentCurrency—payment currency code according to ISO-4217 alpha-3
    
    Here are the optional parameters:
    
    *   recurrentInfo—object with the details of COF purchase
    *   paymentDescription—payment description (this parameter is available not only to the merchant, but also to the customer; if paymentDescription is specified in the request, it is visible to the customer in the payment form (in the dialog box containing information about the payment); if this parameter is not specified in the request, it is not visible to the customer)
    *   customerID—customer ID
    *   regionCode—customer country
    *   ActionType—action type (`Sale` (by default), `Auth`, `Tokenize`, or `Verify`)
    *   token—card token
    *   forcePaymentMethod—the identifier of the payment method which is opened to the customer without an option for the customer to select another payment method. The list of codes is provided in the [IDs of payment methods supported on Payment Page](en_PP__Paramaters_ForcePaymentMethod.html) section
    *   hideSavedWallets—hiding or displaying saved payment instruments in the payment form. Possible values:
        *   `true`—saved payment instruments are hidden, they are not displayed in the payment form.
        *   `false`—saved payment instruments are displayed in the payment form.
    *   hideScanningCards - hiding or displaying button to start card scanning flow
    *   ECommPayHostsScreenDisplayMode — object to manage display of the final page of the payment form and hide the final page if necessary. The following parameters can be passed in the object:
        
        *   `hide_success_final_page`—the final page with the message about the performed payment is not displayed in the payment form.
        *   `hide_decline_final_page`—the final page with the message about the declined payment is not displayed in the payment form.
        
        The following is an example of specifying the `HIDE_SUCCESS_FINAL_PAGE ` and `HIDE_DECLINE_FINAL_PAGE ` parameters in the request:
        
            // Init paymentInfo object
             
            [paymentInfo addScreenDisplayMode: HIDE_SUCCESS_FINAL_PAGE];
            [paymentInfo addScreenDisplayMode: HIDE_DECLINE_FINAL_PAGE];
        
4.  Pack all the payment parameters into a string for signing:
    
    paymentInfo.getParamsForSignature();
    
5.  Send the string to your back end.
6.  Have your back end generate the signature on the basis of the string and your secret key.
7.  Add signature in your `PaymentInfo` object:
    
    [paymentInfo setSignature:signature];
    
8.  Open the payment form by using the following code:
    
        [self.sdkFacade presentPaymentAt:self paymentInfo:paymentInfo 
             completionHandler:^(ECPPaymentResult *result) {
             NSLog(@"ECommPay SDK finished with status %ld", (long)result.status);
             if (result.error != NULL) { // if error occurred
                 NSLog(@"Error: %@", result.error.localizedDescription);
             }
             if (result.token != NULL) { // if tokenize action
                 NSLog(@"Token: %@", result.token);
             }
         }];
    
Before opening the payment form, the library check for any errors and opens the payment form only if no errors occur. Otherwise, the payment form is not opened and the presentPayment method returns the error code.
    

Response processing
-------------------

To receive and process response with the payment processing results you need to add the following code:

Figure: Receiving response in Swift

    sdkFacade.presentPayment(at: self, paymentInfo: paymentInfo) { (result) in
       print("ECommPay SDK finished with status \(result.status.rawValue)")
       if let error = result.error { // if error encountered
          print("Error: \(error.localizedDescription)")
       }
       if let token = result.token { // if tokenize action performed
          print("Token: \(token)")
       }
     }

Figure: Receiving response in Objective-C

    [self.sdkFacade presentPaymentAt:self paymentInfo:paymentInfo
        completionHandler:^(ECPPaymentResult *result) {
            NSLog(@"ECommPay SDK finished with status %ld", (long)result.status);
            if(result.error != NULL) { // if error encountered
                NSLog(@"Error: %@", result.error.localizedDescription);
            }
            if(result.token != NULL) {  // if tokenize action performed
                NSLog(@"Token: %@", result.token);
            }
     }];

The result code is returned in the paymentStatus parameter.

The following table lists possible response codes returned in the paymentStatus parameter.

Value in paymentStatus

Description

0

Checkout successfully completed.

100

Operation was declined, for example because of insufficient funds.

301

Operation was cancelled by the customer.

501

An internal error occurred. You may need to contact technical support.

Callbacks
---------

### Overview

When using SDK for iOS, the merchant can receive callbacks that are sent by the payment platform directly to merchant web service and callbacks that are first sent by the payment platform to SDK for iOS and then by SDK for iOS to merchant mobile application. In the former case, the parameters sent in callbacks may vary depending on the configurations. In the latter case, specific set of parameters is provided—the data about status, type and ID of the payment, currency and amount of the payment as well as the payment method that was used:

    {
        "payment": {
            "status": "success",
            "type": "purchase",
            "id": "12345",
            "date": "2020-09-11T14:49:18+0000",
            "method": "card",
            "sum": 1000,
            "currency": "USD"
             }
    }

The following sections provide information about these callback messages.

### Callbacks sent by the payment platform

The payment platform sends all the callback messages to the callback URL you specify. You need to contact the ECommPay technical support and provide the URL to send callbacks.

### Callbacks sent by SDK for iOS

Merchant mobile application can receive callback messages with information about purchase processing result from SDK for iOS as information about payment processing result is sent to SDK for iOS by the payment platform. The callback message is sent to the merchant before the page with information about the result is displayed to the customer on the payment form.

To obtain information about payment result, you need to use the ECMPCallback public protocol. This protocol involves the use of the onPaymentResult method which comes into action automatically as the final payment status is received and, as a result, the merchant receives information about the payment result. To obtain information about the purchase processing result, you can use the following examples of the code with no additional setup; if needed, you can also change the code.

Figure: Swift

    class YourClass: ECMPCallback {
        func presentPaymentPage() {
            sdkFacade = EcommpaySDK(callback: self)
            ...
        }
     
        func onPaymentResult(paymentData: ECMPPaymentData) {
            // callback
        }
    }

Figure: Objective-C

    @interface YourClass() <ECMPCallback> { EcommpaySDK * sdkFacade; }
     
    @implementation YourClass
     
    ...
     
    - (void)presentPaymentPage {
        self.sdkFacade = [[EcommpaySDK alloc] initWithCallback: self];
        ...
    }
     
    - (void)onPaymentResult:(ECMPPaymentData *)paymentData {
        // callback
    }

Funding and AFT
---------
### Overview
The ECommPay SDK supports funding and AFT operations. To support that feature you shoud set additional properties of `PaymentInfo` object before pass it to the SDK.

### Card operations
Funding operartions with Card requires additional fields to be added to the `PaymentInfo` object.
These two additional fields are requered:
    *   account_id - recipient's account identifier
    *   customer_country - code of the customer's country in ISO 3166-1 alpha-2 format

Figure: Swift

    // Init paymentInfo object

    paymentInfo.setAdditionalFields(additionalFields: [
          ...
          AdditionalField(type: .customer_account_id, value: "customer_account_id"),
          AdditionalField(type: .customer_country, value: "US"),
          ...
    ]

Figure: Objective-C
    
    // Init paymentInfo object

    [paymentInfo setAdditionalFields:@[
                 ...
                 [[AdditionalField alloc] initWithType:customer_account_id value:@"customer_account_id"],
                 [[AdditionalField alloc] initWithType:customer_country value:@"US"],
                 ...
    ]];

### ApplePay
Funding operartions with Apple pay requires `RecipientInfo` object to be assigned to the `recipient Info` property of `PaymentInfo` instance.

Figure: Swift

    // Init paymentInfo object

    let recipient = RecipientInfo(walletOwner: "Mark",
                                      walletId: "722202c53",
                                      country: "US")
    paymentInfo.recipientInfo = recipient

Figure: Objective-C

    // Init paymentInfo object
             
    RecipientInfo *recipient = [[RecipientInfo alloc] initWithWalletOwner:@"Mark"
                                                                 walletId:@"722202c53"
                                                                  country:@"US"];
    [paymentInfo setRecipientInfo:recipient];

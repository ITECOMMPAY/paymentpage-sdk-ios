//
//  ViewController.m
//  IntegrationExampleObjc
//
//  Created by Deniss Kaibagarovs on 07/02/2019.
//  Copyright © 2019 Ecommpay. All rights reserved.
//

#import "ViewController.h"
#import "IntegrationExampleObjc-Swift.h"

#import <EcommpaySDK/EcommpaySDK.h>

#define SECRET @"your_secret"
#define PROJECT_ID 10 // your project id

@interface ViewController ()
@property (nonatomic, strong) EcommpaySDK *ecommpaySDK;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init SDK
    self.ecommpaySDK = [[EcommpaySDK alloc] init];
    
    // Create payment info with product information
    PaymentInfo *paymentInfo = [self getPaymentInfoOnlyRequiredParams]; //getPaymentInfoAllParams
    
    #warning("Signature should be generated on your server and delivered to your app")
    NSString *signature = [self getSignature:paymentInfo.getParamsForSignature];
    
    // Sign payment info
    [paymentInfo setSignature:signature];
    
    [self.ecommpaySDK presentPaymentAt:self paymentInfo:paymentInfo completionHandler:^(ECPPaymentResult *result) {
        NSLog(@"ecommpaySDK finisehd with status %ld", (long)result.status);
        if(result.error != NULL) { // if error occurred
            NSLog(@"Error: %@", result.error.localizedDescription);
        }
        if(result.token != NULL) { // if tokenize action
            NSLog(@"Token: %@", result.token);
        }
    }];
}

#pragma mark - Payment Info

- (PaymentInfo *)getPaymentInfoOnlyRequiredParams {
    return [[PaymentInfo alloc] initWithProjectID:PROJECT_ID // project ID that is assigned to you
                                        paymentID:@"internal_payment_id_1" // payment ID to identify payment in your system
                                    paymentAmount:1999 // 19.99
                                  paymentCurrency:@"USD"];
}

- (PaymentInfo *)getPaymentInfoAllParams {
    return [[PaymentInfo alloc] initWithProjectID:PROJECT_ID // project ID that is assigned to you
                                        paymentID:@"internal_payment_id_1" // payment ID to identify payment in your system
                                    paymentAmount:1999 // 19.99
                                  paymentCurrency:@"USD"
                               paymentDescription:@"T-shirt with dog print"
                                       customerID:@"10" // unique ID assigned to your customer
                                       regionCode:@""];
}

#pragma mark - Signature

- (NSString *)getSignature:(NSString *)stringToSign {
    return [Utils signature:stringToSign secret:SECRET];
}

#pragma mark - Additionals

- (void)setDMSPayment:(PaymentInfo *)paymentInfo {
    [paymentInfo setAction:ActionTypeAuth];
}

- (void)setActionTokenize:(PaymentInfo *)paymentInfo {
    [paymentInfo setAction:ActionTypeTokenize];
}

- (void)setActionVerify:(PaymentInfo *)paymentInfo {
    [paymentInfo setAction:ActionTypeVerify];
}

- (void)setToken:(PaymentInfo *)paymentInfo {
    [paymentInfo setToken:@"token"];
}

- (void)setReceiptData:(PaymentInfo *)paymentInfo {
    [paymentInfo setReceiptData:@"receipt data"];
}

- (void)setRecurrent:(PaymentInfo *)paymentInfo {
    RecurrentInfo *recurrentInfo = [[RecurrentInfo alloc] initWithRecurrentType:RecurrentTypeAutopayment
                                                                      expiryDay:@"20"
                                                                    expiryMonth:@"11"
                                                                     expiryYear:@"2030"
                                                                         period:RecurrentPeriodMonth
                                                                           time:@"12:00:00"
                                                                      startDate:@"12-02-2020"
                                                             scheduledPaymentID:@"your_recurrent_id"];
    // Additional options if needed
//    [recurrentInfo setAmount:1000];
//    [recurrentInfo setSchedule:@[[[RecurrentInfoSchedule alloc] initWithDate:@"10-10-2020" amount:1200],
//                                 [[RecurrentInfoSchedule alloc] initWithDate:@"10-11-2020" amount:1000]]];
    
    [paymentInfo setRecurret:recurrentInfo];
}

- (void)setKnownAdditionalFields:(PaymentInfo *)paymentInfo {
    [paymentInfo setAdditionalFields:@[[[AdditionalField alloc] initWithType:customer_first_name value:@"Mark"],
                                       [[AdditionalField alloc] initWithType:billing_country value:@"US"]]];
}

#pragma mark - Theme

- (void)setDarkTheme {
    ECPTheme *theme = [ECPTheme getDarkTheme];
    // Additional changes if needed
//    theme.backgroundColor = UIColor.greenColor;
//    theme.showDarkKeyboard = true;
    [self.ecommpaySDK setTheme:theme];
}

@end

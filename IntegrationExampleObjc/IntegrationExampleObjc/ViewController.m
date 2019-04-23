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
    
    // Present Checkout UI
    [self.ecommpaySDK presentPaymentAt:self paymentInfo:paymentInfo completionHandler:^(ECPPaymentStatus paymentStatus, NSError * error) {
        NSLog(@"ecommpaySDK finisehd with status %ld", (long)paymentStatus);
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
    [paymentInfo setCreditCardPaymentType:CreditCardPaymentTypeAuth];
}

- (void)setToken:(PaymentInfo *)paymentInfo {
    [paymentInfo setToken:@"token"];
}

- (void)setRecurrent:(PaymentInfo *)paymentInfo {
    RecurrentInfo *recurrentInfo = [[RecurrentInfo alloc] initWithRecurrentType:RecurrentTypeAutopayment
                                                                    expiryMonth:@"11"
                                                                     expiryYear:@"2030"
                                                                         period:RecurrentPeriodMonth
                                                                           time:@"12:00:00"
                                                                      startDate:@"12-02-2020"
                                                             scheduledPaymentID:@"your_recurrent_id"];
    
    [paymentInfo setRecurret:recurrentInfo];
}

@end

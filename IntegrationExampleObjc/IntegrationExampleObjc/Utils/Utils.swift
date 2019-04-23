//
//  Utils.swift
//  TestClient
//
//  Created by Ecommpay on 8/10/18.
//  Copyright © 2018 Ecommpay. All rights reserved.
//

import UIKit
import ecommpaySDK

class Utils: NSObject {
    @objc(signature:secret:)
    class func signature(paramsToSign: String, secret: String) -> String {
        return paramsToSign.sha512(secret: secret)!.base64EncodedString();
    }
}

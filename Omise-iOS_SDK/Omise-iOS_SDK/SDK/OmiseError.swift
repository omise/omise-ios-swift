//
//  OmiseError.swift
//  Omise-iOS_SDK
//
//  Created by Anak Mirasing on 6/13/2558 BE.
//  Copyright (c) 2558 omise. All rights reserved.
//

import UIKit

let OmiseErrorDomain = "co.omise"

public enum OmiseErrorCode: Int {
    case OmiseTimeoutError = 92661
    case OmiseServerConnectionError
    case OmiseBadRequestError
    case OmiseUnknownError
}

public class OmiseError: NSObject {
   
}

//
//  Result.swift
//  DarkSkySwift-iOS
//
//  Created by Ciprian Redinciuc on 13/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

public enum JSONResult {
    case success(SuccessJSONResponse)
    case failure(FailureJSONResponse)

    public init(data: Data?, response: HTTPURLResponse, error: NSError?) {
        if let requestError = error {
            let failure = FailureJSONResponse(jsonObject: data, response: response, error: requestError)
            self = .failure(failure)
        } else {
            let success = SuccessJSONResponse(jsonObject: data, response: response)
            self = .success(success)
        }
    }

    public var error: NSError? {
        switch self {
        case .success(_):
            return nil
        case .failure(let response):
            return response.error
        }
    }
}

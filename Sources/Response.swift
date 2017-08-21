//
//  Response.swift
//  DarkSkySwift
//
//  Created by Ciprian Redinciuc on 06/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

/// HTTP Status code types.
/// Read more about it here: http://www.restapitutorial.com/httpstatuscodes.html
public enum StatusCodeType {
    case informational
    case success
    case redirection
    case clientError
    case serverError
    case cancelled
    case unknown
}

// MARK: - Extension that helps easier decide which type of status code the reponse is.
public extension Int {
    var statusCodeType: StatusCodeType {
        switch self {
        case URLError.cancelled.rawValue:
            return .cancelled
        case 100 ..< 200:
            return .informational
        case 200 ..< 300:
            return .success
        case 300 ..< 400:
            return .redirection
        case 400 ..< 500:
            return .clientError
        case 500 ..< 600:
            return .serverError
        default:
            return .unknown
        }
    }
}

/// Base response class.
public class Response {
    public let URLResponse: HTTPURLResponse

    public var statusCode: Int {
        return URLResponse.statusCode
    }

    public var headers: [AnyHashable: Any] {
        return URLResponse.allHeaderFields
    }

    init(response: HTTPURLResponse) {
        self.URLResponse = response
    }
}

/// Base failure response class.
public class FailureResponse: Response {
    public let error: NSError

    init(response: HTTPURLResponse, error: NSError) {
        self.error = error
        super.init(response: response)
    }
}

/// JSON Reponse class
public class JSONResponse: Response {
    public let jsonData: Data?

    init(jsonObject: Data?, response: HTTPURLResponse) {
        self.jsonData = jsonObject
        super.init(response: response)
    }
}

/// A successfull JSON reponse class.
public class SuccessJSONResponse: JSONResponse { }

/// A failure JSON reponse class.
public class FailureJSONResponse: JSONResponse {
    public let error: NSError

    init(jsonObject: Data?, response: HTTPURLResponse, error: NSError) {
        self.error = error
        super.init(jsonObject: jsonObject, response: response)
    }
}

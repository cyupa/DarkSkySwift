//
//  RequestTests.swift
//  DarkSkySwift
//
//  Created by Ciprian Redinciuc on 21/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import XCTest
import DarkSkySwift

class RequestTests: XCTestCase {
    private let baseURL = "http://api.darksky.net"
    private let parameters = ["lang": "en"]
    private let authKey = "Auth"
    private let authValue = "Token"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPutRequestCreation() {
        let request = requestWithMethod(method: .put, path: "/forecast", parametersType: .json)
        var urlRequest: URLRequest?
        urlRequest = request.urlRequest(relativeTo: baseURL)

        XCTAssertNotNil(urlRequest)
    }

    func testPostRequestCreation() {
        let request = requestWithMethod(method: .get, path: "/forecast", parametersType: .urlFormEncoded)
        var urlRequest: URLRequest?
        urlRequest = request.urlRequest(relativeTo: baseURL)

        XCTAssertNotNil(urlRequest)
    }

    func testDeleteRequestCreation() {
        let request = requestWithMethod(method: .post, path: "/forecast", parametersType: .multiparFormData)
        var urlRequest: URLRequest?
        urlRequest = request.urlRequest(relativeTo: baseURL)

        XCTAssertNotNil(urlRequest)
    }

    func testWrongPathCreation() {
        let request = requestWithMethod(method: .post, path: "forecast", parametersType: .json)
        var urlRequest: URLRequest?
        urlRequest = request.urlRequest(relativeTo: baseURL)

        XCTAssertNil(urlRequest)
    }

    func requestWithMethod(method: HTTPMethod, path: String, parametersType: ParametersType) -> Request {
        return Request(method: method,
                       path: path,
                       parameters:parameters,
                       parametersType: parametersType,
                       token: nil,
                       authorizationHeaderValue: authValue,
                       authorizationHeaderKey: authKey,
                       completion: nil)
    }
}

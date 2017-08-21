//
//  ApiClientTests.swift
//  DarkSkySwift
//
//  Created by Ciprian Redinciuc on 21/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import XCTest
import DarkSkySwift
import OHHTTPStubs

class ApiClientTests: XCTestCase {
    private let baseURL = "https://api.darksky.net"
    private let token = "token"
    private let authHeader = "authHeader"
    private let authKey = "authKey"

    private let responseHeaders = [ "Content-Type": "application/json" ]

    override func setUp() {
        super.setUp()
        let successPath = "/forecast"
        let failurePath = "/forecast_fail"

        stub(condition: isHost("api.darksky.net") && pathStartsWith(successPath)) { _ in
            guard let filePath = OHPathForFile("darkskyresponse_si.json", type(of: self)) else {
                preconditionFailure("Could not find json file")
            }

            return OHHTTPStubsResponse(fileAtPath: filePath,
                                       statusCode: 200,
                                       headers: self.responseHeaders)
        }

        stub(condition: isHost("api.darksky.net") && pathStartsWith(failurePath)) { _ in
            return OHHTTPStubsResponse(data: Data() ,
                                       statusCode: 404,
                                       headers: self.responseHeaders)
        }
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testCacheConfig() {
        let client = APIClient(baseURL: baseURL, configuration: .`default`)
        XCTAssertNotNil(client.session)
    }
    
    func testNoCacheConfig() {
        let client = APIClient(baseURL: baseURL, configuration: .noCaching)
        XCTAssertNotNil(client.session)
    }


    func testBackgroundConfig() {
        let token = "token"
        let client = APIClient(baseURL: baseURL, configuration: .background(sessionIdentifier: token))
        let configuration = client.session.configuration.identifier
        XCTAssertNotNil(client.session)
        XCTAssertTrue(configuration == configuration)
    }

    func testSuccessPutRequest() {
        let client = APIClient(baseURL: baseURL, configuration: .`default`)

        let expectation = self.expectation(description: "Response is returned")
        client.put("/forecast",
                   token: nil,
                   authorizationHeader: authHeader,
                   authorizationKey: authKey) { (result) in
                    switch result {
                    case .success(let response):
                        XCTAssertNotNil(response.jsonData)
                    case .failure(_):
                        XCTFail()
                    }
                    expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 0.5)
    }

    func testFailurePostRequest() {
        let client = APIClient(baseURL: baseURL, configuration: .`default`)

        let expectation = self.expectation(description: "Response is not returned")
        client.post("/forecast_fail",
                    token: nil,
                    authorizationHeader: authHeader,
                    authorizationKey: authKey) { (result) in
                        XCTAssertNotNil(result.error)
                        switch result {
                        case .success(_):
                            XCTFail()
                        case .failure(let response):
                            XCTAssertTrue(response.statusCode.statusCodeType == .clientError)
                            XCTAssertNotNil(response.error)
                        }
                    expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 0.5)
    }

    func testSuccessDeleteRequest() {
        let client = APIClient(baseURL: baseURL, configuration: .`default`)

        let expectation = self.expectation(description: "Response is returned")
        client.delete( "/forecast",
                   token: nil,
                   authorizationHeader: authHeader,
                   authorizationKey: authKey) {(result) in
                    switch result {
                    case .success(let response):
                        XCTAssertTrue(response.statusCode.statusCodeType == .success)
                        XCTAssertNotNil(response.headers)
                        XCTAssertNotNil(response.jsonData)
                    case .failure(_):
                        XCTFail()
                    }
                    expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 0.5)
    }
}

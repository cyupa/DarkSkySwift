//
//  DarkSkySwiftForecastRequestTests.swift
//  DarkSkySwift
//
//  Created by Ciprian Redinciuc on 18/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import XCTest
import OHHTTPStubs
import DarkSkySwift

class DarkSkySwiftForecastRequestTests: XCTestCase {

    private static let correctMockToken = "mockToken"
    private static let wrongMockToken = "wrongMockToken"

    override func setUp() {
        super.setUp()

        let correctPath = "/forecast/\(DarkSkySwiftForecastRequestTests.correctMockToken)"
        let wrongPath = "/forecast/\(DarkSkySwiftForecastRequestTests.wrongMockToken)"
        let headers = [ "Content-Type": "application/json" ]

        stub(condition: isHost("api.darksky.net") && pathStartsWith(correctPath)) { _ in
            guard let filePath = OHPathForFile("darkskyresponse_si.json", type(of: self)) else {
                preconditionFailure("Could not find json file")
            }

            return OHHTTPStubsResponse(fileAtPath: filePath,
                                       statusCode: 200,
                                       headers: headers)
        }

        stub(condition: isHost("api.darksky.net") && pathStartsWith(wrongPath)) { _ in
            return OHHTTPStubsResponse(data: Data() ,
                                       statusCode: 404,
                                       headers: headers)
        }
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testForecastIsReturned() {
        let client = DarkSkyClient(with: DarkSkySwiftForecastRequestTests.correctMockToken)
        let expectation = self.expectation(description: "Forecast response is returned")

        client.getForecastFor(location: (latitude: 0, longitude: 0)) { (forecast, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(forecast)
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 0.5)
    }

    func testForecastIsNotReturned() {
        let client = DarkSkyClient(with: DarkSkySwiftForecastRequestTests.wrongMockToken)
        let expectation = self.expectation(description: "Forecast response is not returned")

        client.getForecastFor(location: (latitude: 0, longitude: 0)) { (forecast, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(forecast)
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 0.5)
    }

    func testNoToken() {
        let client = DarkSkyClient(with: DarkSkySwiftForecastRequestTests.correctMockToken)
        client.token = nil
        let expectation = self.expectation(description: "Token is deleted")

        client.getForecastFor(location: (latitude: 0, longitude: 0)) { (forecast, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(forecast)
            expectation.fulfill()
        }

        self.wait(for: [expectation], timeout: 0.5)
    }
}

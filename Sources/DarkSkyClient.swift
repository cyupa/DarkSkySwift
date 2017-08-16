//
//  DarkSkyClient.swift
//  DarkSkySwift-iOS
//
//  Created by Ciprian Redinciuc on 14/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

open class DarkSkyClient: APIClient {

    private static let baseURL = "https://api.darksky.net"

    public init(with darkSkyToken: String) {
        super.init(baseURL: DarkSkyClient.baseURL, configuration: .default, cache: nil)
        self.token = darkSkyToken
        DarkSkyClient.errorDomainName = "com.applicodo.darkSkyApi"
    }

    public func getForecastFor(location: (latitude: Double, longitude: Double), completion: @escaping(_ forecast: Forecast?, _ reponse: Any?, _ error: NSError?) -> Void) {
        let longitude = String.init(describing: location.longitude)
        let latitude = String.init(describing: location.latitude)
        if let apiToken = token {
            let path = requestPath(withToken: apiToken, path: "forecast", latitude: latitude, longitude: longitude)
            handleGETRequest(with: path, completion: completion)
        } else {
            let error = NSError(domain: DarkSkyClient.errorDomainName, code: 0, userInfo: [NSLocalizedDescriptionKey : "No token provided"])
            completion(nil, nil, error)
        }
    }

    private func handleGETRequest(with path: String, completion: @escaping(_ forecast: Forecast?, _ reponse: Any?, _ error: NSError?) -> Void) {
        get(path, parameters: nil, parametersType: nil, responseType: .json, token: nil, authorizationHeader: nil, authorizationKey: nil) { (result) in
            switch result {
            case .success(let response):
                let forecast = Forecast()
                completion(forecast, response.jsonDictionary, nil)
            case .failure(let response):
                completion(nil, response.jsonDictionary, response.error)
            }
        }
    }

    private func requestPath(withToken: String, path: String, latitude: String, longitude: String) -> String {
        return "/\(path)/\(withToken)/\(latitude),\(longitude)"
    }
}

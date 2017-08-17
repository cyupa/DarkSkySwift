//
//  DarkSkyClient.swift
//  DarkSkySwift-iOS
//
//  Created by Ciprian Redinciuc on 14/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

/// Dark Sky API client class. You can use this to query the Dark Sky API for forecasts using your API token.
open class DarkSkyClient: APIClient {
    
    /// The Dark Sky API base URL.
    private static let baseURL = "https://api.darksky.net"

    /// The `units` URL encodable query parameter key.
    private static let unitsParamKey = "units"
    /// The `lang` URL encodable query parameter key.
    private static let languageParamKey = "lang"
    
    /// The designated initializer
    ///
    /// - Parameter darkSkyToken: Your Dark Sky API secret token.
    public init(with darkSkyToken: String) {
        super.init(baseURL: DarkSkyClient.baseURL, configuration: .default, cache: nil)
        self.token = darkSkyToken
        // Set a custom domain name
        DarkSkyClient.errorDomainName = "com.applicodo.darkSkyApi"
    }
    
    /// Get the full forecast for the given location. This method looks at the device's locale to determine the language and unit format for the forecast reponse.
    ///
    /// - Parameters:
    ///   - location: A (latitude, longitude) tuple representing the coordinates for which you want to recieve the forecast.
    ///   - completion: Completion block called when the API call returns.
    public func getForecastFor(location: (latitude: Double, longitude: Double), completion: @escaping(_ forecast: Forecast?, _ error: NSError?) -> Void) {
        let longitude = String.init(describing: location.longitude)
        let latitude = String.init(describing: location.latitude)
        if let apiToken = token {
            let path = requestPath(withToken: apiToken, path: "forecast", latitude: latitude, longitude: longitude)
            handleGETRequest(with: path, completion: completion)
        } else {
            let error = NSError(domain: DarkSkyClient.errorDomainName, code: 0, userInfo: [NSLocalizedDescriptionKey : "No token provided"])
            completion(nil, error)
        }
    }

    
    /// Tranlates the API query into a GET request.
    ///
    /// - Parameters:
    ///   - path: The path relative to the base URL.
    ///   - completion: The completion block composed of a optional `Forecast` object and an optional `NSError`
    private func handleGETRequest(with path: String, completion: @escaping(_ forecast: Forecast?, _ error: NSError?) -> Void) {
        let params = [DarkSkyClient.unitsParamKey: unitsParam,
                      DarkSkyClient.languageParamKey: languageParam]

        get(path, parameters: params, parametersType: .urlFormEncoded, responseType: .json, token: nil, authorizationHeader: nil, authorizationKey: nil) { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                var forecast: Forecast?
                if let data = response.jsonData {
                    forecast = try! decoder.decode(Forecast.self, from: data)
                }
                completion(forecast, nil)
            case .failure(let response):
                completion(nil, response.error)
            }
        }
    }
    
    /// Function that composes the request path.
    ///
    /// - Parameters:
    ///   - withToken: The Dark Sky API token
    ///   - path: The path requested.
    ///   - latitude: The coordinate latitude.
    ///   - longitude: The coordinate longitude.
    /// - Returns: A `String` instance representing the full path.
    private func requestPath(withToken: String, path: String, latitude: String, longitude: String) -> String {
        return "/\(path)/\(withToken)/\(latitude),\(longitude)"
    }

    
    /// The current device locale
    private var locale: Locale {
        return NSLocale.autoupdatingCurrent
    }

    /// The current device's language. It defaults to en.
    private var languageParam: String {
        return (locale.languageCode != nil) ? locale.languageCode! : "en"
    }

    
    /// The units type string depending on the device's region code. Defaults to "si" for countries that use the metric system and "us" for the rest with exceptions for the UK and Canada.
    private var unitsParam: String {
        var units  = "us" // Imperial units
        if locale.usesMetricSystem {
            units = "si" // SI units
        }

        if let regionCode = locale.regionCode {
            switch regionCode.lowercased() {
            case "ca":
                units = "ca" // wind speed is in kilometers per hour
            case "uk":
                units = "uk2" // wind speed and visibility are in miles per hour and miles
            default:
                break
            }
        }
        return units
    }
}

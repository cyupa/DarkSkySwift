//
//  APIClient.swift
//  DarkSkySwift
//
//  Created by Ciprian Redinciuc on 06/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

open class APIClient {
    /// The error domain name
    static var errorDomainName = "com.applicodo.apiclient"


    /// The client's base URL.
    public let baseURL: String

    // Client configuration type: `defaulf`, `noCaching` or `background(name)`, where name is the given name of the configuration used by the NSURLSession.
    public var configurationType: ConfigurationType

    /// The response cache.
    public var cache: NSCache<AnyObject, AnyObject>

    /// The API client token.
    public var token: String?

    /// If any calls return a 403 or 401 message, this closure will be called.
    public var unauthorizedRequestCallback: (()-> Void)?

    /// The URLSession object created with the given configuration.
    lazy public var session: URLSession = {
        let configuration = self.configurationType.urlSessionConfiguration()
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        return URLSession.init(configuration: configuration)
    }()

    /// Designated initialized
    ///
    /// - Parameters:
    ///   - baseURL: The base URL string of the API client
    ///   - configuration: A configuration type to initialize the URLSession with
    public init(baseURL: String, configuration: ConfigurationType, cache: NSCache<AnyObject, AnyObject>? = nil) {
        self.baseURL = baseURL
        self.configurationType = configuration
        self.cache = cache ?? NSCache()
    }
}


/// This enum describes the URLSessionConfiguration type that the APIClient will use.
///
/// - `default`: By using this, the APICLient will use the URLSessionConfiguration.default type
/// - noCaching: This will make APIClient use the URLSessionConfiguration ephemeral configuration, which means it does not store caches, credential stores, or any session-related data to disk.
/// - background: Allows uploads and downloads to happen on a background thread. Using the same idetifier will allow you to continue a download or upload even if the app is terminated or suspended.
public enum ConfigurationType {
    case `default`
    case noCaching
    case background(sessionIdentifier: String)

    func urlSessionConfiguration() -> URLSessionConfiguration {
        switch self {
        case .`default`:
            return URLSessionConfiguration.default
        case .noCaching:
            return URLSessionConfiguration.ephemeral
        case .background(let sessionIdentifier):
            return URLSessionConfiguration.background(withIdentifier: sessionIdentifier)
        }
    }
}

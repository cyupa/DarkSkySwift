//
//  Request.swift
//  DarkSkySwift
//
//  Created by Ciprian Redinciuc on 06/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

/// HTTP Methods.
/// Read more about them here: https://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html
public enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

/// Describes how the parameters will be serialized and determines the 'Content-Type' header value.
///
/// - none: No Content-Type header
/// - json: The parameters will be serialized to JSON and the `Content-Type` will be `application/json`.
/// - urlFormEndoced: The parameters will be percent-endoded and the `Content-Type` will be
/// `application/x-www-form-urlencoded`.
/// - multiparFormData: Use this for the upload of files, forms. It will set the `Content-Type` to
/// `multipart/form-data`.
/// - custom: This will sent the content as plain data and will set the `Content-Type` to the value you provide.
public enum ParametersType {
    case none
    case json
    case urlFormEncoded
    case multiparFormData
    case custom(String)

    /// Returns the content type for a given parameter type.
    ///
    /// - Parameter boundary: If the type is `multiparFormData` the caller must also provide a boundary string.
    /// - Returns: The content-type string for the given parameter type.
    func contentType(_ boundary: String?) -> String? {
        switch self {
        case .none:
            return nil
        case .json:
            return "application/json"
        case .urlFormEncoded:
            return "application/x-www-form-urlencoded"
        case .multiparFormData:
            if let boundaryValue = boundary {
                return "multipart/form-data; boundary=\(boundaryValue)"
            } else {
                return nil
            }
        case .custom(let value):
            return value
        }
    }
}

/// Describes the response type accepted by the request.
public enum ResponseType {
    case json
    case image
    case other

    /// Generates the accepted type string.
    var accept: String? {
        switch self {
        case .json:
            return "application/json"
        case .image:
            return "image/*"
        default:
            return nil
        }
    }
}

typealias RequestCompletion = (Any?, HTTPURLResponse, NSError?) -> Void

/// Class that describes a request object.
open class Request {
    /// The HTTP method.
    let method: HTTPMethod

    /// The path relative to the base url.
    var path: String

    /// The request parameters.
    var parameters: Any?

    /// The request parameters type. If the type is JSON they will be set in the HTTP Body, if they
    /// are URLFormEncoded, they will be appended to the URL.
    var parametersType: ParametersType?
    var responseType: ResponseType?
    var token: String?
    var authorizationHeaderValue: String?
    var authorizationHeaderKey: String?
    var completion: (_ response: Any?, _ httpResponse: HTTPURLResponse, _ error: NSError?) -> Void

    /// Designated initializer that contains all the required data to compose a URLRequest.
    ///
    /// - Parameters:
    ///   - method: The HTTP method for the request.
    ///   - path: The path relative to the base URL for the request.
    ///   - parameters: The parameters used for composing the HTTP request. This should be used along
    /// with `parametersType` to determine how the parameters will be passed along.
    ///   - parametersType: Describes the type of parameters.
    ///   - responseType: Describes the expected response type.
    ///   - token: The Beared token htat will be set to the HTTP authorization header key.
    ///   - authorizationHeaderValue: The value that will be set to the HTTP authorization header key.
    /// Use this or the token, not both.
    ///   - authorizationHeaderKey: The HTTP authorization header key.
    ///   - completion: The completion block that will be called after the request executes.
    init(method: HTTPMethod,
         path: String,
         parameters: Any? = nil,
         parametersType: ParametersType? = nil,
         responseType: ResponseType? = nil,
         token: String? = nil,
         authorizationHeaderValue: String? = nil,
         authorizationHeaderKey: String? = nil,
         completion: @escaping RequestCompletion) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.parametersType = parametersType
        self.responseType = responseType
        self.token = token
        self.authorizationHeaderValue = authorizationHeaderValue
        self.authorizationHeaderKey = authorizationHeaderKey
        self.completion = completion
    }

    /// Composes a URLRequest object from the Request object
    ///
    /// - Parameter baseURL: The base URL against which the full URL will be composed
    /// - Returns: A URL Request if succesful. Nil if not.
    func urlRequest(relativeTo baseURL: String) -> URLRequest? {
        var requestObject: URLRequest?
        var serializationError: NSError?

        do {
            // Create the URL
            let urlObject = try url(relativeTo: baseURL)
            // Create the URL request using the URL
            requestObject = URLRequest(url: urlObject)
            if var request = requestObject {
                // Set the HTTP method to be used
                request.httpMethod = method.rawValue
                do {
                    // Set the HTTP body
                    request.httpBody = try getHTTPBody()
                    request.addValue("gzip;q=1.0, compress;q=0.5", forHTTPHeaderField: "Accept-Encoding")

                    // Set the accepted type
                    if let acceptType = responseType?.accept {
                        request.addValue(acceptType, forHTTPHeaderField: "Accept")
                    }

                    // Se the Content-Type set to the server
                    if let contentType = parametersType?.contentType(nil) {
                        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
                    }

                    // Handle the authorization header
                    if let authKey = authorizationHeaderKey {
                        if let authHeader = authorizationHeaderValue {
                            request.setValue(authHeader, forHTTPHeaderField: authKey)
                        } else if let authToken = token {
                            let value = "Bearer \(authToken)"
                            request.setValue(value, forHTTPHeaderField: authKey)
                        }
                    }
                } catch let error as NSError {
                    // Catch any serialization error
                    serializationError = error
                }
            }
        } catch let error as NSError {
            serializationError = error
        }

        if let error = serializationError {
            // Complete with a serialization error
            let urlObject = try? url(relativeTo: baseURL)
            if let url = urlObject {
                let response = HTTPURLResponse(url: url, statusCode: error.code, httpVersion: nil, headerFields: nil)
                if let urlResponse = response {
                    completion(nil, urlResponse, error)
                } else {
                    fatalError("Cannot create URL Reponse")
                }
            }
        }
        return requestObject
    }

    /// Composes the URL. This method looks at the parametersType and if it is set to `.urlFormEncoded`,
    /// the parameters will be appended the the URL.
    ///
    /// - Parameter baseURL: The base URL against which the full URL will be composed.
    /// - Returns: The request URL or nil.
    /// - Throws: Can throw errors regarding the URL initialization or parameters convertion.
    public func url(relativeTo baseURL: String) throws -> URL {
        // Tries to create the base URL
        guard var components = URLComponents(string: baseURL) else {
            let info = [NSLocalizedDescriptionKey: "Cannot initialize URL from baseURL: \(baseURL)"]
            throw NSError(domain: APIClient.errorDomainName, code: 0, userInfo: info)
        }
        // Appends the URL path
        components.path = self.path

        if let paramsType = parametersType {
            switch paramsType {
            case .urlFormEncoded:
                // If the parameters are URL form encoded, they are added to the URL.
                if let paramsDict = parameters as? [String: Any] {
                    var queryItems = [URLQueryItem]()
                    for (key, value) in paramsDict {
                        let stringValue = String(describing: value)
                        let queryItem = URLQueryItem(name: key, value: stringValue)
                        queryItems.append(queryItem)
                    }
                    components.queryItems = queryItems
                } else {
                    let infoString = "Cannot convert parameters \(String(describing: self.parameters))"
                    let info = [NSLocalizedDescriptionKey: infoString]
                    throw NSError(domain: APIClient.errorDomainName, code: 0, userInfo: info)
                }
            default: break
            }
        }

        // Tries to create the full URL
        guard let url = components.url else {
            let info = [NSLocalizedDescriptionKey: "Cannot initialize the full path URL from baseURL: \(baseURL)"]
            throw NSError(domain: APIClient.errorDomainName, code: 0, userInfo: info)
        }
        return url
    }

    /// Generated the HTTP Body based on the request `parameters` and `parametersType`.
    ///
    /// - Returns: Data object containing the parameters that can be used as the HTTP Request body or nil.
    /// - Throws: Can throw serialization erorrs.
    private func getHTTPBody() throws -> Data? {
        var bodyData: Data?
        if let paramsType = parametersType {
            switch paramsType {
            case .none: break
            case .json:
                if let params = parameters {
                    bodyData = try JSONSerialization.data(withJSONObject: params, options: [])
                }
            default: break
            }
        }
        return bodyData
    }
}

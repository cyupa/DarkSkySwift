//
//  APIClient+Requests.swift
//  DarkSkySwift-iOS
//
//  Created by Ciprian Redinciuc on 08/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

public extension APIClient {

    public func get(_ path: String,
                    parameters: Any? = nil,
                    parametersType: ParametersType? = .json,
                    responseType: ResponseType? = .json,
                    token: String?,
                    authorizationHeader: String?,
                    authorizationKey: String?,
                    completion: @escaping (_: JSONResult) -> Void ) {

        let request = jsonRequest(method: .get,
                                  path: path,
                                  parameters: parameters,
                                  parametersType: parametersType,
                                  responseType: responseType,
                                  token: token,
                                  authorizationHeader: authorizationHeader,
                                  authorizationKey: authorizationKey,
                                  completion: completion)
        execute(request)
    }

    public func put(_ path: String,
                    parameters: Any? = nil,
                    parametersType: ParametersType? = .json,
                    responseType: ResponseType? = .json,
                    token: String?,
                    authorizationHeader: String?,
                    authorizationKey: String?,
                    completion: @escaping (_: JSONResult) -> Void ) {

        let request = jsonRequest(method: .put,
                                  path: path,
                                  parameters: parameters,
                                  parametersType: parametersType,
                                  responseType: responseType,
                                  token: token,
                                  authorizationHeader: authorizationHeader,
                                  authorizationKey: authorizationKey,
                                  completion: completion)
        execute(request)
    }

    public func post(_ path: String,
                     parameters: Any? = nil,
                     parametersType: ParametersType? = .json,
                     responseType: ResponseType? = .json,
                     token: String?,
                     authorizationHeader: String?,
                     authorizationKey: String?,
                     completion: @escaping (_: JSONResult) -> Void ) {

        let request = jsonRequest(method: .post,
                                  path: path,
                                  parameters: parameters,
                                  parametersType: parametersType,
                                  responseType: responseType,
                                  token: token,
                                  authorizationHeader: authorizationHeader,
                                  authorizationKey: authorizationKey,
                                  completion: completion)
        execute(request)
    }

    public func delete(_ path: String,
                       parameters: Any? = nil,
                       parametersType: ParametersType? = .json,
                       responseType: ResponseType? = .json,
                       token: String?,
                       authorizationHeader: String?,
                       authorizationKey: String?,
                       completion: @escaping (_: JSONResult) -> Void ) {

        let request = jsonRequest(method: .delete,
                                  path: path,
                                  parameters: parameters,
                                  parametersType: parametersType,
                                  responseType: responseType,
                                  token: token,
                                  authorizationHeader: authorizationHeader,
                                  authorizationKey: authorizationKey,
                                  completion: completion)
        execute(request)
    }

    private func jsonRequest(method: HTTPMethod,
                             path: String, parameters: Any? = nil,
                             parametersType: ParametersType? = .json,
                             responseType: ResponseType? = .json,
                             token: String? = nil,
                             authorizationHeader: String? = nil,
                             authorizationKey: String? = nil,
                             completion: @escaping (_: JSONResult) -> Void ) -> Request {

        let request = Request(method: method,
                              path: path,
                              parameters: parameters,
                              parametersType: parametersType,
                              responseType: responseType,
                              token: token,
                              authorizationHeaderValue: authorizationHeader,
                              authorizationHeaderKey: authorizationKey) { data, response, error in
            let result = JSONResult(data: data as? Data, response: response, error: error)
            completion(result)
        }

        return request
    }

    private func execute(_ request: Request) {
        let urlRequest = request.urlRequest(relativeTo: baseURL)
        var responseData: Data?
        var urlResponse: URLResponse?
        var connectionError: Error?

        if let httpURLRequest = urlRequest {
            let dataTask = session.dataTask(with: httpURLRequest) { [weak self] (data, response, error) in
                responseData = data
                urlResponse = response
                connectionError = error

                if let httpURLResponse = response as? HTTPURLResponse {
                    if httpURLResponse.statusCode.statusCodeType == .success {
                        if let returnedData = data, returnedData.count > 0 {
                            responseData = returnedData
                        }
                    } else {
                        connectionError = self?.errorFrom(httpURLResponse: httpURLResponse, error: error)
                    }
                }

                var isUnauthorized = false
                if let error = connectionError as NSError? {
                    isUnauthorized = error.code == 403 || error.code == 401
                }
                if let unauthCallback = self?.unauthorizedRequestCallback, isUnauthorized {
                    unauthCallback()
                } else {
                    if let response = urlResponse as? HTTPURLResponse, let completion = request.completion {
                        completion(responseData, response, connectionError as NSError?)
                    } else if let baseURL = self?.baseURL {
                        let url = try? request.url(relativeTo: baseURL)
                        let errorCode = (connectionError as NSError?)?.code ?? 200
                        if let url = url {
                            // swiftlint:disable line_length
                            let response = HTTPURLResponse(url: url, statusCode: errorCode, httpVersion: nil, headerFields: nil)
                            // swiftlint:enable line_length
                            if let urlResponse = response, let completion = request.completion {
                                completion(responseData, urlResponse, connectionError as NSError?)
                            } else {
                                fatalError("Cannot create URL Reponse")
                            }
                        } else {
                            fatalError("Cannot create URL")
                        }
                    }
                }
            }
            dataTask.resume()
        } else {
            fatalError("Cannot create URL Request")
        }
    }

    private func errorFrom(httpURLResponse: HTTPURLResponse, error: Error?) -> NSError {
        var errorCode = httpURLResponse.statusCode
        if let returnedError = error as NSError?, returnedError.code == URLError.cancelled.rawValue {
            errorCode = returnedError.code
        }
        let userInfoDescription = HTTPURLResponse.localizedString(forStatusCode: httpURLResponse.statusCode)
        let userInfoDict =  [NSLocalizedDescriptionKey: userInfoDescription]
        return NSError(domain: APIClient.errorDomainName, code: errorCode, userInfo: userInfoDict)
    }
}

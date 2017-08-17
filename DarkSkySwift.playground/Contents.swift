//: Playground - noun: a place where people can play

import DarkSkySwift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var token = "" // Insert your API token here

let apiClient = DarkSkyClient(with: token)

let location = (47.156944, 27.590278)

if !token.isEmpty {
    apiClient.getForecastFor(location: location) { (forecast, error) in
        print(forecast ?? "No forecast")
        if let requestError = error {
            print(requestError)
        }
        PlaygroundPage.current.finishExecution()
    }
}


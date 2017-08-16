//: Playground - noun: a place where people can play

import DarkSkySwift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var token = "" // Insert your API token here

let apiClient = DarkSkyClient(with: token)

let location = (47.156944, 27.590278)

apiClient.getForecastFor(location: location) { (forecast, response, error) in
    print(forecast)
    print(response)
    print(error)
    PlaygroundPage.current.finishExecution()
}


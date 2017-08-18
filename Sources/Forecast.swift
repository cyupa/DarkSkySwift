//
//  Forecast.swift
//  DarkSkySwift
//
//  Created by Ciprian Redinciuc on 14/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

/// Class that describes the Forecast response from DarkSky API
public struct Forecast: Codable {

    /// The requested latitude.
    let latitude: Double

    /// The requested longitude.
    let longitude: Double

    /// The IANA timezone name for the requested location. This is used for text summaries and for
    /// determining when `hourly` and `daily` data block objects begin.
    /// E.g. `America/New_York`
    let timezoneString: String

    /// A `ForecastDataPoint` object containing the current weather conditions at the requested location.
    let currently: ForecastDataPoint?

    /// A `ForecastDataBlock` containing the weather conditions minute-by-minute for the next hour.
    let minutely: ForecastDataBlock?

    /// A `ForecastDataBlock` object containing the weather conditions hour-by-hour for the next two days.
    let hourly: ForecastDataBlock?

    /// A `ForecastDataBlock` object containing the weather conditions day-by-day for the next week.
    let daily: ForecastDataBlock?

    /// An `ForecastAlert` objects array, which, if present, contains any severe weather alerts
    /// pertinent to the requested location.
    let alerts: [ForecastAlert]?

    /// A `ForecastFlag` object containing miscellaneous metadata about the request.
    let flags: ForecastFlag?

    /// Codable protocol coding keys. Used to encode/decode from/to a JSON object.
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case currently
        case minutely
        case hourly
        case daily
        case alerts
        case flags
        case timezoneString = "timezone"
    }
}

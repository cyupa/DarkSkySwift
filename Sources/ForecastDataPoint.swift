//
//  ForecastDataPoint.swift
//  DarkSkySwift-iOS
//
//  Created by Ciprian Redinciuc on 17/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

/// A ForecastDataPoint object contains various properties, each representing the average (unless otherwise specified)
/// of a particular weather phenomenon occurring during a period of time:
/// an instant in the case of `currently`, a minute for `minutely`, an hour for `hourly`, and a day for `daily`.
public struct ForecastDataPoint: Codable {

    /// The apparent (or “feels like”) temperature in degrees Fahrenheit / Celsius. Not on `daily`.
    let apparentTemperature: Double?

    /// The maximum value of `apparentTemperature` during a given day. Only on `daily`.
    let apparentTemperatureMax: Double?

    /// The UNIX time of when `apparentTemperatureMax` occurs during a given day. Only on `daily`.
    let apparentTemperatureMaxTime: Date?

    /// The minimum value of `apparentTemperature` during a given day. Only on `daily`.
    let apparentTemperatureMin: Double?

    /// The UNIX time of when `apparentTemperatureMin` occurs during a given day. Only on `daily`.
    let apparentTemperatureMinTime: Date?

    /// The percentage of sky occluded by clouds, between 0 and 1, inclusive.
    let cloudCover: Double?

    /// The dew point in degrees Fahrenheit / Celsius.
    let dewPoint: Double?

    /// The relative humidity, between 0 and 1, inclusive.
    let humidity: Double?

    /// A machine-readable text summary of this data point, suitable for selecting an icon for display.
    /// If defined, this property will have one of the following values: `clear-day`, `clear-night`,
    /// `rain`, `snow`, `sleet`, `wind`, `fog`, `cloudy`, `partly-cloudy-day`, or `partly-cloudy-night`.
    /// (Developers should ensure that a sensible default is defined, as additional values, such as `hail`,
    /// `thunderstorm`, or `tornado`, may be defined in the future.)
    let icon: String?

    /// The fractional part of the lunation number during the given day: a value of `0` corresponds
    /// to a new moon, `0.25` to a first quarter moon, `0.5` to a full moon, and `0.75` to a last quarter moon.
    /// (The ranges in between these represent waxing crescent, waxing gibbous, waning gibbous,
    /// and waning crescent moons, respectively.) Only on `daily`.
    let moonPhase: Double?

    /// The approximate direction of the nearest storm in degrees, with true north at 0° and progressing clockwise.
    /// (If `nearestStormDistance` is zero, then this value will not be defined.) Only on `currently`.
    let nearestStormBearing: Double?

    /// The approximate distance to the nearest storm in miles. (A storm distance of `0` doesn’t necessarily refer
    /// to a storm at the requested location, but rather a storm in the vicinity of that location.)
    /// Only on `currently`.
    let nearestStormDistante: Double?

    /// The columnar density of total atmospheric ozone at the given time in Dobson units.
    let ozone: Double?

    /// The amount of snowfall accumulation expected to occur, in inches. (If no snowfall is expected,
    /// this property will not be defined.) Only on `hourly` and `daily`.
    let precipitationAccumulation: Double?

    /// The intensity (in inches of liquid water per hour) of precipitation occurring at the given time.
    /// This value is conditional on probability (that is, assuming any precipitation occurs at all)
    /// for `minutely` data points, and unconditional otherwise.
    let precipitationIntensity: Double?

    /// The maximum value of precipIntensity during a given day. Only on `daily`.
    let precipitationIntensityMax: Double?

    /// The UNIX time of when `precipitationIntensityMaxTime` occurs during a given day. Only on `daily`.
    let precipitationIntensityMaxTime: Date?

    /// The probability of precipitation occurring, between 0 and 1, inclusive.
    let precipitationProbability: Double?

    /// The type of precipitation occurring at the given time. If defined, this property will have one
    /// of the following values: `"rain"`, `"snow"`, or `"sleet"` (which refers to each of freezing rain,
    /// ice pellets, and “wintery mix”). (If `precipIntensity` is zero, then this property will not be defined.)
    let precipitationType: String?

    /// The sea-level air pressure in millibars.
    let pressure: Double?

    /// A human-readable text summary of this data point. (This property has millions of possible values,
    /// so don’t use it for automated purposes: use the `icon` property, instead!)
    let summary: String?

    /// The UNIX time of when the sun will rise during a given day. Only on `daily`.
    let sunriseTime: Date?

    /// The UNIX time of when the sun will set during a given day. Only on `daily`.
    let sunsetTime: Date?

    /// The air temperature in degrees Fahrenheit / Celsius. Not on `minutely`.
    let temperature: Double?

    /// The maximum value of `temperature` during a given day. Only on `daily`.
    let temperatureMax: Double?

    /// The UNIX time of when `temperatureMax` occurs during a given day. Only on `daily`.
    let temperatureMaxTime: Date?

    /// The minimum value of `temperature` during a given day. Only on `daily`.
    let temperatureMin: Double?

    /// The UNIX time of when `temperatureMin` occurs during a given day. Only on `daily`.
    let temperatureMinTime: Date?

    /// The UNIX time at which this data point begins. `minutely` data point are always aligned to
    /// the top of the minute, `hourly` data point objects to the top of the hour, and `daily` data
    /// point objects to midnight of the day, all according to the local time zone.
    let time: Date

    /// The UV index.
    let uvIndex: Double?

    /// The UNIX time of when the maximum `uvIndex` occurs during a given day. Only on `daily`.
    let uvIndexTime: Date?

    /// The average visibility in miles, capped at 10 miles / km.
    let visibility: Double?

    /// The direction that the wind is coming from in degrees, with true north at 0° and progressing
    /// clockwise. (If `windSpeed` is zero, then this value will not be defined.)
    let windBearing: Double?

    /// The wind gust speed in miles per hour.
    let windGust: Double?

    /// The UNIX time of when the maximum `windGust` occurs during a given day. Only on `daily`.
    let windGustTime: Date?

    /// The wind speed in miles per hour.
    let windSpeed: Double?

    /// Codable protocol coding keys. Used to encode/decode from/to a JSON object.
    enum CodingKeys: String, CodingKey {
        case apparentTemperature
        case apparentTemperatureMax
        case apparentTemperatureMaxTime
        case apparentTemperatureMin
        case apparentTemperatureMinTime
        case cloudCover
        case dewPoint
        case humidity
        case icon
        case moonPhase
        case nearestStormBearing
        case nearestStormDistante
        case ozone
        case precipitationAccumulation = "precipAccumulation"
        case precipitationIntensity = "precipIntensity"
        case precipitationIntensityMax = "precipIntensityMax"
        case precipitationIntensityMaxTime = "precipIntensityMaxTime"
        case precipitationProbability = "precipProbability"
        case precipitationType = "precipType"
        case pressure
        case summary
        case sunriseTime
        case sunsetTime
        case temperature
        case temperatureMax
        case temperatureMaxTime
        case temperatureMin
        case temperatureMinTime
        case time
        case uvIndex
        case uvIndexTime
        case visibility
        case windBearing
        case windGust
        case windGustTime
        case windSpeed
    }
}

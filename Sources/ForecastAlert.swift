//
//  ForecastAlert.swift
//  DarkSkySwift
//
//  Created by Ciprian Redinciuc on 17/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

/// The severity of the weather alert.
///
/// - advisory: an individual should be aware of potentially severe weather
/// - watch: an individual should prepare for potentially severe weather
/// - warning: an individual should take immediate action to protect themselves and others from
/// potentially severe weather
public enum AlertSeverity: String, Codable {
    case advisory
    case watch
    case warning
}

/// The ForecastAlert objects represent the severe weather warnings issued for the requested location
/// by a governmental authority (please see our data sources page for a list of sources).
public struct ForecastAlert: Codable {

    /// A detailed description of the alert.
    let descriptionString: String

    /// The UNIX time at which the alert will expire. (Some alerts sources, unfortunately, do not
    /// define expiration time, and in these cases this parameter will not be defined.)
    let expires: Date?

    /// An array of strings representing the names of the regions covered by this weather alert.
    let regions: [String]

    /// The severity of the weather alert.
    let severity: AlertSeverity

    /// The UNIX time at which the alert was issued.
    let time: Date

    /// A brief description of the alert.
    let title: String

    /// An HTTP(S) URI that one may refer to for detailed information about the alert.
    let uri: URL

    /// Codable protocol coding keys. Used to encode/decode from/to a JSON object.
    enum CodingKeys: String, CodingKey {
        case descriptionString = "description"
        case expires
        case regions
        case severity
        case time
        case title
        case uri
    }
}

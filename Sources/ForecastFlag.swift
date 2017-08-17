//
//  ForecastFlag.swift
//  DarkSkySwift
//
//  Created by Ciprian Redinciuc on 17/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

/// The ForecastFlag object contains various metadata information related to the request.
public struct ForecastFlag: Codable {
    
    /// The presence of this property indicates that the Dark Sky data source supports the given location, but a temporary error (such as a radar station being down for maintenance) has made the data unavailable.
    let unavailable: Bool?

    /// This property contains an array of IDs for each data source utilized in servicing this request.
    let sources: [String]?

    /// This property contains an array of IDs for each meteo station utilized in servicing this request.
    let stations: [String]?
    
    /// Indicates the units which were used for the data in this request.
    let units: String?
    
    /// Codable protocol coding keys. Used to encode/decode from/to a JSON object.
    enum CodingKeys: String, CodingKey {
        case sources
        case stations
        case units
        
        case unavailable = "darksky-unavailable"
    }
}

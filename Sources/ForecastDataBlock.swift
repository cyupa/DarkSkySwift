//
//  ForecastDataBlock.swift
//  DarkSkySwift
//
//  Created by Ciprian Redinciuc on 17/08/2017.
//  Copyright © 2017 Applicodo. All rights reserved.
//

import Foundation

/// A ForecastDataBlock object represents the various weather phenomena occurring over a period of time
public struct ForecastDataBlock: Codable {
    
    /// A human-readable summary of this data block.
    let summary: String?
    
    /// An array of `ForecastDataPoint` objects, ordered by time, which together describe the weather conditions at the requested location over time.
    let dataPoints: [ForecastDataPoint]?

    /// A machine-readable text summary of this data block. (May take on the same values as the iconproperty of data points.)
    let icon: String?
    
    /// Codable protocol coding keys. Used to encode/decode from/to a JSON object.
    enum CodingKeys: String, CodingKey {
        case summary
        case dataPoints = "data"
        case icon
    }
}

//
//  StopsComponentModel.swift
//  SpotsDemo
//
//  Created by Håkon Knutzen on 10/12/2017.
//  Copyright © 2017 Håkon Knutzen. All rights reserved.
//

import Foundation
import UIKit
import Spots

struct StopsModel: Codable {
    struct Layout: Codable {
        let itemSpacing: Double
        let span: Double
    }
    struct Stop: Codable {
        let name: String
    }
    let kind: String
    let layout: Layout
    let data: [Stop]
}

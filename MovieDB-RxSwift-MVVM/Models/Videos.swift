//
//  Videos.swift
//  MovieDB-RxSwift-MVVM
//
//  Created by Finn Christoffer Kurniawan on 18/02/23.
//

import Foundation

struct VideoResponse: Codable {
    var results: [Video]
}

struct Video: Codable {
    let id: String
    let name: String
    let key: String
}



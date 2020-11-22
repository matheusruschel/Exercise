//
//  News.swift
//  Exercise
//
//  Created by Matheus Ruschel on 2020-11-21.
//

import Foundation

struct News: Codable {
    var id: Int
    var by: String?
    var score: Int?
    var text: String?
    var time: Int?
    var title: String?
    var type: String?
    var url: String?
    var story: String?
}

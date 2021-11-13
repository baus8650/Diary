//
//  Entry.swift
//  Diary
//
//  Created by Tim Bausch on 10/24/21.
//

import Foundation

struct Entry: Decodable {
    let user: String
    let date: String
    let body: String
    let mood: Int
    let id: String
    let timeStamp: Double
}

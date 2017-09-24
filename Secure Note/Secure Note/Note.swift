//
//  Note.swift
//  Secure Note
//
//  Created by Andrew Johnson on 9/24/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import Gloss

struct Note: DatabaseDocument {
    
    // MARK: Properties
    
    static let documentType: DocumentType? = .note
    static let sortKey: String = Keys.createdDate.rawValue
    
    let id: String
    var text: String
    var createdDate: Date
}


// MARK: Json Keys

extension Note {

    enum Keys: String {
        case id = "_id"
        case text = "text"
        case createdDate = "createdDate"
    }
}


// MARK: Glossy

extension Note: Glossy {

    init?(json: JSON) {
        id = Keys.id.rawValue <~~ json ?? ""
        text = Keys.text.rawValue <~~ json ?? ""
        createdDate = Decoder.decode(dateISO8601ForKey: Keys.createdDate.rawValue)(json) ?? Date()
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            Keys.id.rawValue ~~> id,
            Keys.text.rawValue ~~> text,
            Encoder.encode(dateISO8601ForKey: Keys.createdDate.rawValue)(createdDate)
        ])
    }
}

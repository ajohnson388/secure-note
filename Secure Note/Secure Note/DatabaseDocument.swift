//
//  DatabaseDocument.swift
//  Secure Note
//
//  Created by Andrew Johnson on 9/23/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import Gloss

protocol DatabaseDocument {
    static var documentType: DocumentType? { get }
    static var sortKey: String { get }
    var id: String { get }
    init?(json: [String: Any])
    func toJson() -> [String: Any]?
}


extension DatabaseDocument where Self: Glossy {
    
    init?(json: [String: Any]) {
        self.init(json: json)
    }
    
    func toJson() -> [String: Any]? {
        return self.toJSON()
    }
}

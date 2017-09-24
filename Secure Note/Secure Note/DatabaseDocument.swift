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


// MARK: Glossy Defaults

extension DatabaseDocument where Self: Glossy {
    
    init?(json: [String: Any]) {
        self.init(json: json)
    }
    
    func toJson() -> [String: Any]? {
        return self.toJSON()
    }
}


// MARK: Data Provider Functions

extension DatabaseDocument {

    static func get(withId id: String, completionHandler: @escaping (Self?) -> ()) {
        DataProvider.getDocument(withId: id, callback: completionHandler)
    }
    
    static func getBatch(startAt index: Int, amount: Int, completionHandler: @escaping ([Self]) -> ()) {
        DataProvider.getBatch(startAt: index, amount: amount, callback: completionHandler)
    }
    
    static func save(completionHandler: @escaping () -> ()) {
        guard let document = self as? Self else {
            // TODO: Log unusual error?
            return
        }
        DataProvider.save(document: document, completionHandler: completionHandler)
    }
}


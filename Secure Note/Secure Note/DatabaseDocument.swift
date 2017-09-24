//
//  DatabaseDocument.swift
//  Secure Note
//
//  Created by Andrew Johnson on 9/23/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation

protocol DatabaseDocument {
    static var documentType: DocumentType? { get }
    var id: String { get }
    init?(json: [String: Any])
    func toJson() -> [String: Any]
}

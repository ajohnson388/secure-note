//
//  DataProvider.swift
//  Secure Note
//
//  Created by Andrew Johnson on 9/23/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation

struct DataProvider {
    
    // MARK: Properties

    fileprivate static let dbName = "secure_note_db"
}


// MARK: Configuration

extension DataProvider {
    
    static func initView(forDocumentType type: DocumentType, database: CBLDatabase, sortKey: String) -> CBLView {
        let view = database.viewNamed(type.rawValue)
        view.documentType = type.rawValue
        let mapBlock: CBLMapBlock = { doc, emit in
            if let key = doc[sortKey] as? String {
                emit(key, doc)
            }
        }
        let reduceBlock: CBLReduceBlock = { keys, values, rereduce in return values.count }
        view.setMapBlock(mapBlock, reduce: reduceBlock, version: "0")
        return view
    }
}


// MARK: Getters

extension DataProvider {
    
    static func getDocument<T>(withId id: String, callback: @escaping (T?) -> ()) where T: DatabaseDocument {
        CBLManager.sharedInstance().backgroundTellDatabaseNamed(dbName) { db in
            // Get the document json
            guard let json = db.existingDocument(withID: id)?.properties else {
                DispatchQueue.main.async { callback(nil) }
                return
            }
            
            // Instantiate and return the object
            let object = T(json: json)
            DispatchQueue.main.async { callback(object) }
        }
    }
    
    static func getBatch<T>(startAt index: Int, amount: Int, callback: @escaping ([T]) -> ()) where T: DatabaseDocument {
        CBLManager.sharedInstance().backgroundTellDatabaseNamed(dbName) { db in
            // Get the document view
            guard let documentType = T.documentType else {
                return
            }
            let view = db.existingViewNamed(documentType.rawValue) ?? initView(forDocumentType: documentType,
                                                                               database: db, sortKey: T.sortKey)
            
            // Create the queryy
            let query = view.createQuery()
            query.skip = UInt(abs(amount))
            query.prefetch = true
            
            do {
                // Run the query
                let enumerator = try query.run()
                
                // Collect a batch of objects
                var batch = [T]()
                while let row = enumerator.nextRow() {
                    guard batch.count < amount else {
                        break
                    }
                    guard let json = row.documentProperties else {
                        // TODO: Log error
                        continue
                    }
                    guard let object = T(json: json) else {
                        // TODO: Log error
                        continue
                    }
                    batch.append(object)
                }
                DispatchQueue.main.async { callback(batch) }
            } catch {
                // Log error and return empty list
                // TODO: Log
                DispatchQueue.main.async { callback([]) }
            }
        }
    }
}


// MARK: Setters

extension DataProvider {

    static func save<T>(document: T, completionHandler: @escaping () -> ()) where T: DatabaseDocument {
        CBLManager.sharedInstance().backgroundTellDatabaseNamed(dbName) { db in
            
            defer {
                DispatchQueue.main.async(execute: completionHandler)
            }
            
            // Get the new json
            guard let json = document.toJson() else {
                // TODO: Log error
                return
            }
        
            // Get the original document
            guard let document = db.document(withID: document.id) else {
                // TODO: Log error
                return
            }
            
            // Update the document with the new json
            do {
                try document.putProperties(json)
            } catch {
                // TODO: Log error
            }
        }
    }
}


// MARK: Utilities

extension DataProvider {
    
    static func startTask(_ task: @escaping () -> ()) {
        
    }
}

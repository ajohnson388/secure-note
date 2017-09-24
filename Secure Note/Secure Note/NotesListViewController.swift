//
//  NotesListViewController.swift
//  Secure Note
//
//  Created by Andrew Johnson on 9/24/17.
//  Copyright © 2017 Andrew Johnson. All rights reserved.
//

import Foundation
import UIKit

final class NotesListViewController: UITableViewController {

    // MARK: Properties
    
    fileprivate let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose,
                                                target: nil, action: nil)
    
    fileprivate var notes: [Note] = []
    
    
    // MARK: Initializers
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



// MARK: UIViewController LifeCycle

extension NotesListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupTableView()
    }
}


// MARK: Setup

fileprivate extension NotesListViewController {

    func setupNavbar() {
        // Set title
        navigationItem.title = "Notes"
        
        // Setup create button
        navigationItem.rightBarButtonItem = addButton
        addButton.target = self
        addButton.action = #selector(didTapCreate(_:))
    }
    
    func setupTableView() {
    
    }
}


// MARK: Selectors

extension NotesListViewController {

    func didTapCreate(_ sender: UIBarButtonItem) {
        // TODO: Navigate to new note
    }
}


// MARK: UITableView DataSource

extension NotesListViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "note_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
            ?? UITableViewCell(style: .default, reuseIdentifier: reuseId)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text
        return cell
    }
}


// MARK: UITableView Delegate

extension NotesListViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

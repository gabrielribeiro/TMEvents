//
//  EventDetailViewController.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import UIKit

class EventDetailViewController: UITableViewController, EventDetailViewControllerDelegate {
    
    private let viewModel = EventDetailViewModel()
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    func configure(for event: Event) {
        title = event.name
        
        viewModel.setData(for: event)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)

        let row = viewModel.items[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = row.value
        content.secondaryText = row.rowType.title
        
        cell.contentConfiguration = content

        return cell
    }
    
    // MARK: - EventDetailViewControllerDelegate
    
    func didSetData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

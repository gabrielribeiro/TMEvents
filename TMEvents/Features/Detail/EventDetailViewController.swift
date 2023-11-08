//
//  EventDetailViewController.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 08/11/23.
//

import UIKit

class EventDetailViewController: UITableViewController, EventDetailViewControllerDelegate {
    
    private let viewModel: EventDetailViewModel
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    init(viewModel: EventDetailViewModel = EventDetailViewModel()) {
        self.viewModel = viewModel
        
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Event info"
        
        viewModel.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    func configure(for event: Event) {
        viewModel.setData(for: event)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: self.getFavImage(),
            style: .plain,
            target: self,
            action: #selector(toggleFavoriteButtonTapped)
        )
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "Favorite_Button"
    }
    
    @objc func toggleFavoriteButtonTapped() {
        viewModel.toggleFavorite()
    }
    
    private func getFavImage() -> UIImage {
        let favoriteImage = UIImage(systemName: "star")
        let unfavoriteImage = UIImage(systemName: "star.fill")
        
        return viewModel.isEventFavorited() ? unfavoriteImage! : favoriteImage!
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
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.reloadData()
            
            strongSelf.navigationItem.rightBarButtonItem?.image = strongSelf.getFavImage()
        }
    }
}

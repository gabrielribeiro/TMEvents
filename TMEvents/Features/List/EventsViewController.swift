//
//  EventsViewController.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 07/11/23.
//

import UIKit

class EventsViewController: UITableViewController, UISearchResultsUpdating, EventsViewControllerDelegate {
    
    private let viewModel = EventsViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    var coordinator: AppCoordinator?
    
    convenience init() {
        self.init(style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Simple TM Events List"
        
        setupTableView()
        setupSearchController()
        
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
    }
    
    private func setupTableView() {
        clearsSelectionOnViewWillAppear = true
        
        tableView.register(EventCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search events"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func showError(message: String?) {
        let alertViewController = UIAlertController(
            title: "Attention!",
            message: message ?? "An unexpected error occured.",
            preferredStyle: .alert
        )
        
        alertViewController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertViewController, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = viewModel.events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath) as! EventCell
        
        cell.configure(for: event, isFavorite: viewModel.isEventFavorited(event))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = viewModel.events[indexPath.row]
        
        coordinator?.pushEvent(event)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            viewModel.fetchDataForNextPage()
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        
        if !searchText.isEmpty {
            viewModel.fetchData(
                searchText: searchText,
                page: 0
            )
        } else {
            viewModel.fetchData()
        }
    }
    
    // MARK: - EventsViewControllerDelegate
    
    func didFail(with error: Error?) {
        if let error = error as? NSError {
            guard error.code != NSURLErrorCancelled else {
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.hideTableViewPlaceholder()
                }
                return
            }
            
            let title = "Attention!"
            let button = "Retry"
            
            var subtitle = "An unexpected error occured."
            
            switch error.code {
            case NSURLErrorTimedOut:
                subtitle = "Request timed out. Poor connectivity may be the cause."
            case NSURLErrorCannotConnectToHost:
                subtitle = "Cannot connect to the host. Check your internet connection."
            case NSURLErrorNetworkConnectionLost:
                subtitle = "Network connection lost. Poor connectivity detected."
            default:
                subtitle = error.localizedDescription
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.showTableViewPlaceholder(
                    title: title,
                    subtitle: subtitle,
                    button: button,
                    image: UIImage(systemName: "wifi.slash")
                ) { [weak self] in
                    self?.viewModel.retry()
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.hideTableViewPlaceholder()
                self?.showError(message: error?.localizedDescription)
            }
        }
    }
    
    func didFetchWithSuccess() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.viewModel.events.isEmpty {
                strongSelf.tableView.showTableViewPlaceholder(
                    title: "No events found",
                    subtitle: "Try searching for another event",
                    image: UIImage(systemName: "ticket")
                )
            } else {
                strongSelf.tableView.hideTableViewPlaceholder()
            }
            
            strongSelf.tableView.reloadData()
        }
    }
    
    func loadingDidChange(loading: Bool) {
        guard loading else {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                
                strongSelf.tableView.backgroundView = UIView()
            }

            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }

            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.startAnimating()
            
            strongSelf.tableView.backgroundView = activityIndicator
        }
    }
}

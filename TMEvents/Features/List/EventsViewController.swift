//
//  EventsViewController.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 07/11/23.
//

import UIKit

class EventsViewController: UITableViewController, EventsViewControllerDelegate {
    
    private let viewModel = EventsViewModel()
    
    private var loadingAlertViewController: UIAlertController?
    
    private static let reuseIdentifier = "reuseIdentifier"
    
    var coordinator: AppCoordinator?

    convenience init() {
        self.init(style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Simple TM Events List"
        
        self.clearsSelectionOnViewWillAppear = true
        
        self.tableView.register(EventCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
        
        self.tableView.tableFooterView = UIView()
        
        self.viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
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

        cell.configure(for: event)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = viewModel.events[indexPath.row]
        
        coordinator?.pushEvent(event)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    // MARK: - EventsViewControllerDelegate
    
    func didFail(with error: Error?) {
        let alertViewController = UIAlertController(
            title: "Attention!",
            message: error?.localizedDescription ?? "An unexpected error occured.",
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
    
    func didFetchWithSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func loadingDidChange(loading: Bool) {
        guard loading else {
            DispatchQueue.main.async {
                self.loadingAlertViewController?.dismiss(animated: false)
            }
            
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            let loadingAlertViewController = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating();

            loadingAlertViewController.view.addSubview(loadingIndicator)
            
            strongSelf.present(loadingAlertViewController, animated: false, completion: nil)
            
            strongSelf.loadingAlertViewController = loadingAlertViewController
        }
    }
}

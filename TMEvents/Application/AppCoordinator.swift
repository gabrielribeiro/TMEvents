//
//  AppCoordinator.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 07/11/23.
//

import UIKit

class AppCoordinator {
    
    let window: UIWindow
//    let splitViewController: UISplitViewController
    
    init(window: UIWindow) {
        self.window = window
//        self.splitViewController = UISplitViewController()
    
//        configureSplitViewController()
    }

    func start() {
        let eventsViewController = EventsViewController()
//        listViewController.viewModel = listViewModel
//        listViewController.delegate = self

//        let detailViewController = DetailViewController()
//        detailViewController.viewModel = detailViewModel

//        splitViewController.viewControllers = [eventsViewController]

        window.rootViewController = UINavigationController(rootViewController: eventsViewController)
        window.makeKeyAndVisible()
    }

//    private func configureSplitViewController() {
//        splitViewController.preferredDisplayMode = .automatic
//        splitViewController.preferredPrimaryColumnWidthFraction = 0.3
//        splitViewController.maximumPrimaryColumnWidth = 400
//    }
}

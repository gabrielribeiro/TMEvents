//
//  AppCoordinator.swift
//  TMEvents
//
//  Created by Gabriel Ribeiro on 07/11/23.
//

import UIKit

class AppCoordinator {
    
    let window: UIWindow
    
    private var rootViewController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let eventsViewController = EventsViewController()
        eventsViewController.coordinator = self
        
        rootViewController = UINavigationController(rootViewController: eventsViewController)

        window.rootViewController = rootViewController!
        window.makeKeyAndVisible()
    }
    
    func pushEvent(_ event: Event) {
        let detailViewController = EventDetailViewController()
        
        detailViewController.configure(for: event)

        let navigationDetailViewController = UINavigationController(rootViewController: detailViewController)
        navigationDetailViewController.modalPresentationStyle = .formSheet
        rootViewController?.present(navigationDetailViewController, animated: true, completion: nil)
    }
}

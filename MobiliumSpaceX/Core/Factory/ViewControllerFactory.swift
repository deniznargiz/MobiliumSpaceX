//
//  ViewControllerFactory.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 4.02.2023.
//

import UIKit

/// Used Factory pattern to create view controllers
protocol ViewControllerFactory {
    func makeLaunchList() -> LaunchListViewController
    func makeDetail(launchId: String, isUpcoming: Bool) -> LaunchDetailViewController
}

/// Used Dependency container to send shared objects like service
final class DependencyContainer {
    private var service = Service()
}

// MARK: - ViewControllerFactory
extension DependencyContainer: ViewControllerFactory {
    
    func makeLaunchList() -> LaunchListViewController {
        LaunchListViewController(
            factory: self,
            viewModel: LaunchListViewModel(service: service)
        )
    }
    
    func makeDetail(launchId: String, isUpcoming: Bool) -> LaunchDetailViewController {
        LaunchDetailViewController(
            factory: self,
            viewModel: LaunchDetailViewModel(service: service),
            launchId: launchId,
            isUpcoming: isUpcoming
        )
    }
}

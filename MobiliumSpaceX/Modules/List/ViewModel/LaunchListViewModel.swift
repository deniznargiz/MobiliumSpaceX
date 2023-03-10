//
//  LaunchListViewModel.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 4.02.2023.
//

import Foundation

protocol LaunchListViewModelDelegate: AnyObject {
    func upcomingLaunchesDidSet()
    func pastLaunchesDidSet()
    func errorOccured(_ error: Error?)
}

final class LaunchListViewModel {
    
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    private var queryPage = 1
    
    weak var delegate: LaunchListViewModelDelegate?
    
    private(set) var upcomingLaunches = [LaunchResponse]()
    private(set) var pastLaunches = [LaunchResponse]()
    private var queryResponse: QueryResponse!
}

//MARK: 
extension LaunchListViewModel {
    
    func getUpcomingLaunches() {
        setDefaults()
        service.request(api: Endpoint.upcoming) { (response: [LaunchResponse]) in
            self.upcomingLaunches = response
            self.delegate?.upcomingLaunchesDidSet()
        } failure: { err in
            self.delegate?.errorOccured(err)
        }
    }

    func getPastLaunches() {
        setDefaults()
        service.request(api: Endpoint.past) { (response: [LaunchResponse]) in
            self.pastLaunches = response
            self.delegate?.pastLaunchesDidSet()
        } failure: { err in
            self.delegate?.errorOccured(err)
        }
    }
    
    func getQuery(isUpcoming: Bool) {
        service.query(api: Endpoint.query, page: queryPage) { (response: QueryResponse) in
            
            let mapped = response.docs?.compactMap({ $0 }) ?? []

            if isUpcoming {
                self.upcomingLaunches.append(contentsOf: mapped)
                self.delegate?.upcomingLaunchesDidSet()
            } else {
                self.pastLaunches.append(contentsOf: mapped)
                self.delegate?.pastLaunchesDidSet()
            }
           
        } failure: { err in
            self.delegate?.errorOccured(err)
        }
        
        queryPage += 1
    }
    
    func setDefaults() {
        pastLaunches.removeAll()
        upcomingLaunches.removeAll()
        queryPage = 1
    }
}

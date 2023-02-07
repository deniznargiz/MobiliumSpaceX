//
//  LaunchDetailViewModel.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 4.02.2023.
//

import Foundation

protocol LaunchDetailViewModelDelegate: AnyObject {
    func launchDetailDidSet()
    func pastLaunchDetailDidSet()
    func errorOccured(_ error: Error?)
}

final class LaunchDetailViewModel {

    private let service: Service
    
    weak var delegate: LaunchDetailViewModelDelegate?
    
    private(set) var launchDetail: LaunchResponse!
    private(set) var pastLaunchDetail: LaunchResponse!
    
    init(service: Service) {
        self.service = service
    }
}

extension LaunchDetailViewModel {
    
    func getLaunchDetail(launchId: String) {
        service.request(api: Endpoint.detail(launchId)) { (response: LaunchResponse) in
            self.launchDetail = response
            self.delegate?.launchDetailDidSet()
        } failure: { err in
            self.delegate?.errorOccured(err)
        }
    }
    
    func getPastLaunchDetail(launchId: String) {
        service.request(api: Endpoint.detail(launchId)) { (response: LaunchResponse) in
            self.pastLaunchDetail = response
            self.delegate?.pastLaunchDetailDidSet()
        } failure: { err in
            self.delegate?.errorOccured(err)
        }
    }
}

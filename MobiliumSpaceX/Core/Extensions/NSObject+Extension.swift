//
//  NSObject+Extension.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 4.02.2023.
//

import UIKit

extension NSObject {
    
    static var bundle: Bundle {
        Bundle(for: Self.self)
    }
    
    static var className: String {
        String(describing: Self.self)
    }
    
    static var nib: UINib {
        UINib(nibName: className, bundle: bundle)
    }
}

//
//  SceneDelegate.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 4.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let dependencyContainer = DependencyContainer()
        let rootViewController = UINavigationController(rootViewController: dependencyContainer.makeLaunchList())
        rootViewController.navigationBar.isHidden = true
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}


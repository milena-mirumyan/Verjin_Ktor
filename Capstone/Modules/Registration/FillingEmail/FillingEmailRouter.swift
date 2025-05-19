//
//  FillingEmailRouter.swift
//  Capstone
//
//  Created by Milena Mirumyan on 10.05.25.
//

import UIKit

protocol FillingEmailRouterProtocol: AnyObject {
    func navigateToHome()
    func navigateToNextPage(flow: FillingEmailViewFlow, email: String)
}

final class FillingEmailRouter {
    weak var view: UIViewController!
}

extension FillingEmailRouter: FillingEmailRouterProtocol {
    func navigateToHome() {
        view.sceneDelegate.changeRoot(viewController: HomeViewController.create())
    }
    
    func navigateToNextPage(flow: FillingEmailViewFlow, email: String = "") {
        let next = Self.build(flow: flow, email: email)
        view.navigationController?.pushViewController(next, animated: true)
    }
}

extension FillingEmailRouter {
    static func build(flow: FillingEmailViewFlow, email: String = "") -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "FillingEmailViewController") as! FillingEmailViewController
        let presenter = FillingEmailPresenter()
        let router = FillingEmailRouter()
        let interactor = FillingEmailInteractor(
            flow: flow,
            email: email,
            authService: AuthenticationService.shared,
            validationService: FieldValidationService()
        )
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        interactor.presenter = presenter
        router.view = view
        
        return view
    }
}

//
//  FillingEmailPresenter.swift
//  Capstone
//
//  Created by Milena Mirumyan on 10.05.25.
//

final class FillingEmailPresenter: FillingEmailViewOutpuProtocol {
    weak var view: FillingEmailViewInputProtocol!
    var interactor: FillingEmailInteractorInputProtocol!
    var router: FillingEmailRouterProtocol!
    
    func viewDidLoad() {
        switch interactor.flow {
        case .email:
            view.setUpEmailFlow()
        case .registration:
            view.setUpRegistrationFlow()
        case .login:
            view.setUpLoginFlow()
        }
        
        view.setUpHint(message: interactor.flow.hint)
    }
    
    func userDidTapContinue(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        mobileNumber: String,
        confirmPassword: String
    ) {
        if let error = interactor.validate(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            mobileNumber: mobileNumber,
            confirmPassword: confirmPassword
        ) {
            view.showValidationError(error: error)
            return
        }
        
        switch interactor.flow {
        case .email:
            let nextFlow: FillingEmailViewFlow = interactor.isEmailRegistered() ? .login : .registration
            router.navigateToNextPage(flow: nextFlow, email: interactor.email)
        case .registration:
            if let error = interactor.register() {
                view.showAuthError(error: error)
                return
            }
            
            router.navigateToHome()
        case .login:
            if let error = interactor.login() {
                view.showAuthError(error: error)
                return
            }
            
            router.navigateToHome()
        }
    }
}

extension FillingEmailPresenter: FillingEmailInteractorOutputProtocol { }

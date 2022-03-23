//
//  LoginViewController.swift
//  NimbleTest
//
//  Created by rupesh on 20/03/22.
//

import UIKit

class LoginViewController: UIViewController, ErrorHandleProtocol, LoaderProtocol {

    //MARK: - Views
    ///ImageView on the backGround of the ViewController
    ///shows lauchscreen image
    private let backGroundImageView: UIImageView = {
        let tempImageView = UIImageView()
        tempImageView.translatesAutoresizingMaskIntoConstraints = false
        tempImageView.image = UIImage(named: "LaunchScreenImage")
        tempImageView.contentMode = .scaleAspectFill
        return tempImageView
    }()

    ///imageView containing the logo of nimble
    private let nimbleLogoImageView: UIImageView = {
        let tempImageView = UIImageView()
        tempImageView.translatesAutoresizingMaskIntoConstraints = false
        tempImageView.image = UIImage(named: "nimbleLogo")
        tempImageView.contentMode = .scaleAspectFill
        return tempImageView
    }()

    ///textField Configured to enter email Address
    fileprivate let emailTextField: EmailTextField = {
        let tempTextField = EmailTextField()
        tempTextField.textColor = .white
        tempTextField.translatesAutoresizingMaskIntoConstraints = false
        tempTextField.backgroundColor = UIColor(white: 1, alpha: 0.18)
        tempTextField.font = UIFont.loginTextFieldFont
        tempTextField.returnKeyType = .next
        tempTextField.keyboardType = .emailAddress
        return tempTextField
    }()

    ///textField Configured to enter password
    fileprivate let passwordTextField: PasswordTextField = {
        let tempTextField = PasswordTextField()
        tempTextField.textColor = .white
        tempTextField.translatesAutoresizingMaskIntoConstraints = false
        tempTextField.backgroundColor = .clear
        tempTextField.font = UIFont.loginTextFieldFont
        tempTextField.isSecureTextEntry = true
        tempTextField.returnKeyType = .done
        return tempTextField
    }()

    private let forgotPasswordButton: SignInButton = {
        let tempButton = SignInButton()
        tempButton.backgroundColor = .clear
        tempButton.titleLabel?.font = UIFont.forgotPasswordButtonFont
        tempButton.setTitle(AppStrings.login_forgotPassword, for: .normal)
        tempButton.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        return tempButton
    }()

    private let loginButton: SignInButton = {
        let tempButton = SignInButton()
        tempButton.titleLabel?.font = UIFont.loginTextFieldFont
        tempButton.setTitle(AppStrings.login, for: .normal)
        tempButton.setTitleColor(UIColor(white: 0, alpha: 1), for: .normal)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.titleEdgeInsets = UIEdgeInsets(top: 20, left: 12, bottom: 14, right: 12)
        return tempButton
    }()

    ///View holds passphraseTextField and forgotPasswordButton
    private let passwordTextFieldView: PassPhraseView = {
        let tempView = PassPhraseView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        tempView.backgroundColor = UIColor(white: 1, alpha: 0.18)
        return tempView
    }()

    ///Holds All the login interactive views
    private let loginView: UIView = {
        let tempView = UIView()
        tempView.alpha = 0
        tempView.backgroundColor = .clear
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()

    //MARK: - Constraints Data

    ///heightAnchor of nimbleLogoImageView
    private lazy var logoHeightAnchor: NSLayoutConstraint = nimbleLogoImageView.heightAnchor.constraint(equalToConstant: logoInitialHeight)

    ///widthAnchor of nimbleLogoImageView
    private lazy var logoWidthAnchor: NSLayoutConstraint = nimbleLogoImageView.widthAnchor.constraint(equalToConstant: logoInitialWidth)

    ///centerYAnchor of nimbleLogoImageView
    private lazy var logoCenterYAnchor: NSLayoutConstraint =  NSLayoutConstraint(item: self.nimbleLogoImageView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)

    ///initial Height of logo
    private let logoInitialHeight: CGFloat = 48
    ///initial Width of logo
    private let logoInitialWidth: CGFloat = 201.41

    ///logo Height after animation
    private let logoHeightPostAnimation: CGFloat = 40
    ///logo Width after animation
    private let logoWidthPostAnimation: CGFloat = 167.84

    ///Height of emailTExtField
    private let emailTextFieldHeight: CGFloat = 56
    ///spacing between login Views
    private let textFieldSpacing: CGFloat = 20

    ///height of login View
    private lazy var loginViewHeight: CGFloat = (emailTextFieldHeight * 3) + (2 * textFieldSpacing)

    //MARK: - Manager
    ///login Session manager to perform login Session URL Requests
    private let loginSessionManager = LoginSessionManager()

    ///View model fo the login view
    private let loginViewModel = LoginViewModel()

    ///returns if animation is required for view
    private let isAnimationRequired: Bool

    //MARK: - Init

    /// creates LoginViewController object
    /// - Parameter isAnimationRequired: pass if animation is required
    convenience init(isAnimationRequired: Bool) {
        self.init(isAnimationRequired)
    }

    /// creates LoginViewController objec
    /// - Parameter isAnimationRequired: pass if animation is required
    private init(_ isAnimationRequired: Bool){
        self.isAnimationRequired = isAnimationRequired
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }

        //Add Views
        addBackGroundImage()
        addNimbleLogoImageView()
        addloginView()
        addEmailTextField()
        addPasswordTextFieldView()
        addLoginButton()

        //DataModel
        setDataModel()

        if isAnimationRequired{
            //Animate Views
            displayLogoImageView(completion: { [weak self] in
                DispatchQueue.main.async {
                    self?.animateViews()
                }
            })
        }else{
            showViewsWithOutAnimation()
        }
    }

    //MARK: - Data Model

    /// Method sets dataModel to the view
    private func setDataModel(){

        loginViewModel.data.bindAndFire() { [weak self] loginData in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {return}
                weakSelf.loginButton.isEnabled = loginData.isLoginEnabled
            }
        }

        emailTextField.placeholder = loginViewModel.data.value.email.placeHolder
        emailTextField.text = loginViewModel.data.value.email.text
        passwordTextField.placeholder = loginViewModel.data.value.password.placeHolder
        passwordTextField.text = loginViewModel.data.value.password.text

        setEditingEventsObserver(forTextField: emailTextField)
        setEditingEventsObserver(forTextField: passwordTextField)

    }

    //MARK: - Add Views

    ///adds background image to view and set constraints
    private func addBackGroundImage(){
        self.view.addSubview(backGroundImageView)

        NSLayoutConstraint.activate([
            backGroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backGroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            backGroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backGroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    ///adds nimble logo image to view and set constraints
    private func addNimbleLogoImageView(){
        self.view.addSubview(nimbleLogoImageView)

        NSLayoutConstraint.activate([
            logoHeightAnchor,
            logoWidthAnchor,
            logoCenterYAnchor,
            nimbleLogoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }

    ///adds blur affect to backGroundImageView
    ///- returns: UIVisualEffectView which have blurring effect
    private func addBlurEffectView() -> UIVisualEffectView{
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurEffectView.alpha = 0
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        backGroundImageView.addSubview(blurEffectView)

        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: backGroundImageView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: backGroundImageView.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: backGroundImageView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: backGroundImageView.trailingAnchor)
        ])

        self.view.layoutIfNeeded()
        return blurEffectView
    }

    ///adds loginButton view and set constraints
    private func addLoginButton(){
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)

        self.loginView.addSubview(loginButton)

        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: textFieldSpacing),
            loginButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            loginButton.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor),
            loginButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)
        ])
    }

    ///adds loginView and set constraints
    private func addloginView(){
        self.view.addSubview(loginView)

        NSLayoutConstraint.activate([
            loginView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loginView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.872),
            loginView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loginView.heightAnchor.constraint(equalToConstant: loginViewHeight)
        ])
    }

    ///adds emailTextField and set constraints
    private func addEmailTextField(){
        self.loginView.addSubview(emailTextField)
        emailTextField.delegate = self

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: self.loginView.topAnchor),
            emailTextField.widthAnchor.constraint(equalTo: self.loginView.widthAnchor),
            emailTextField.centerXAnchor.constraint(equalTo: self.loginView.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: emailTextFieldHeight)
        ])
    }

    ///adds passwordTextFieldView and set constraints
    /// - Note Method also adds passwordTextField and forgotPasswordButton to passwordTextFieldView
    private func addPasswordTextFieldView(){

        self.loginView.addSubview(passwordTextFieldView)
        NSLayoutConstraint.activate([
            passwordTextFieldView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: textFieldSpacing),
            passwordTextFieldView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextFieldView.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor),
            passwordTextFieldView.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)
        ])

        let forgotPasswordWidth: CGFloat = 70
        self.passwordTextFieldView.addSubview(passwordTextField)
        passwordTextField.delegate = self
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -forgotPasswordWidth)
        ])

        self.passwordTextFieldView.addSubview(forgotPasswordButton)
        NSLayoutConstraint.activate([
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor),
            forgotPasswordButton.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: forgotPasswordWidth)
        ])
    }

    //MARK: - View Animations

    
    /// method displays logo imageView through fade in animation
    /// - Parameter completion: animation to be run after completion of fade in animation
    private func displayLogoImageView(completion: @escaping (()->Void)){
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.nimbleLogoImageView.alpha = 1
        } completion: { isCompleted in
            guard isCompleted else { return }
            completion()
        }
    }

    ///method animate all View positions
    private func animateViews(){

        let blurEffectView = addBlurEffectView()
        logoCenterYAnchor.isActive  = false
        UIView.animate(withDuration: 0.8) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setLogoPositionPostAnimation()
            blurEffectView.alpha = 0.95
            weakSelf.view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 0.8, delay: 0.1) { [weak self] in
            self?.loginView.alpha = 1
        }completion: { [weak self] isCompleted in
            if isCompleted{
                self?.emailTextField.becomeFirstResponder()
            }
        }
    }

    ///method animate logoimageView position
    private func setLogoPositionPostAnimation(){
        logoHeightAnchor.constant = logoHeightPostAnimation
        logoWidthAnchor.constant = logoWidthPostAnimation
        NSLayoutConstraint(item: nimbleLogoImageView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.25, constant: 0).isActive = true
    }
    
    /// Display views without animation
    private func showViewsWithOutAnimation(){
        nimbleLogoImageView.alpha = 1

        let blurEffectView = addBlurEffectView()
        blurEffectView.alpha = 0.95
        loginView.alpha = 1
        logoCenterYAnchor.isActive  = false
        setLogoPositionPostAnimation()
        view.layoutIfNeeded()
    }

    //MARK: - Authentication
    ///called when loginButton is pressed. Checks and perform url session to login
    @objc fileprivate func loginButtonPressed(){
        self.view.endEditing(true)
        guard let email = loginViewModel.data.value.email.text,
              let password = loginViewModel.data.value.password.text,
              loginViewModel.data.value.isLoginEnabled else {
            handle(error: .noDataFound)
            return
        }

        showHud()

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.loginSessionManager.getLoginDetails(emailID: email, password: password) { [weak self] in
                DispatchQueue.main.async {
                        AppDelegate.shared?.window?.rootViewController = SurveyListViewController()
                }
            } errorBlock: { [weak self] error in
                self?.handle(error: error)
            }
        }
    }

}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField{
            loginButtonPressed()
        }
        return true
    }
}

//MARK: - TextFieldEditingEventsDelegate
extension LoginViewController: TextFieldEditingEventsDelegate{

    func textFieldDidChange(_ textField: UITextField) {
        if textField == emailTextField{
            loginViewModel.data.value.email.text = textField.text
        }else if textField == passwordTextField{
            loginViewModel.data.value.password.text = textField.text
        }
    }
}

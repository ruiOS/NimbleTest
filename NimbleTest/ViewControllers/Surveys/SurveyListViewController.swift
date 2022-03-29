//
//  SurveyListViewController.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import UIKit

///Shows list of surveys
class SurveyListViewController:NimbleViewController, LoaderProtocol, CircleViewProtocol, MenuControllerDelegate, NetworkCallErrorProtcol, DisplayAlertProtocol, TokenGenerationErrorProtocol, DataFetchErrorProtocol {

    //MARK: - Views

    ///date label containing today date
    private let dateLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.font = UIFont.dateLabelFont
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.backgroundColor = .clear
        tempLabel.contentMode = .topLeft
        tempLabel.numberOfLines = 1
        tempLabel.isSkeletonEnabled =  true
        tempLabel.lineBreakMode = .byTruncatingTail
        tempLabel.textColor = .white
        return tempLabel
    }()

    ///label containing today string
    private let todayLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.font = UIFont.todayLabelFont
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.backgroundColor = .clear
        tempLabel.contentMode = .topLeft
        tempLabel.textColor = .white
        tempLabel.numberOfLines = 1
        tempLabel.isSkeletonEnabled =  true
        tempLabel.lineBreakMode = .byTruncatingTail
        return tempLabel
    }()

    ///pageControl of the View
    private let pageControl: UIPageControl = {
        let tempPageControl = UIPageControl()
        tempPageControl.translatesAutoresizingMaskIntoConstraints = false
        tempPageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.8)
        tempPageControl.backgroundColor = .clear
        tempPageControl.currentPageIndicatorTintColor = .white
        tempPageControl.contentMode = .left
        tempPageControl.numberOfPages = 3
        tempPageControl.isSkeletonEnabled =  true
        return tempPageControl
    }()

    ///titleLabel containing survey title
    private let titleLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.font = UIFont.surveyTitleLabelFont
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.backgroundColor = .clear
        tempLabel.contentMode = .topLeft
        tempLabel.textColor = .white
        tempLabel.numberOfLines = 2
        tempLabel.isSkeletonEnabled =  true
        tempLabel.lineBreakMode = .byTruncatingTail
        return tempLabel
    }()

    ///descriptionLabel containing survey detail
    private let descriptionLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.font = UIFont.descriptionLabelFont
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.backgroundColor = .clear
        tempLabel.contentMode = .topLeft
        tempLabel.textColor = .white
        tempLabel.numberOfLines = 2
        tempLabel.isSkeletonEnabled =  true
        tempLabel.lineBreakMode = .byTruncatingTail
        return tempLabel
    }()

    ///profle button containing profile details
    private let profileButton: UIButton = {
        let tempButton = UIButton()
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.backgroundColor = .clear
        tempButton.isSkeletonEnabled =  true
        tempButton.setImage(UIImage(named: "Oval"), for: .normal)
        tempButton.imageView?.contentMode = .scaleAspectFit
        return tempButton
    }()

    ///next button to move to next slide of survey
    private let takeSurveyButton: UIButton = {
        let tempButton = UIButton()
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.backgroundColor = .white
        tempButton.isSkeletonEnabled =  true
        tempButton.setImage(UIImage(named: "Arrow"), for: .normal)
        return tempButton
    }()

    //MARK: Menu Controller Views
    ///controller of the menu
    private let menuController = MenuViewController()

    ///view of the menu
    private let menuView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = .clear
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()

    ///back ground view of the menu
    private let menuBackGroundView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = .clear
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()

    //MARK: - Gesture Recognisers

    ///left gesture Recogniser to move page left
    private let leftGestureRecogniser: UISwipeGestureRecognizer = {
        let tempGestreRecogniser = UISwipeGestureRecognizer()
        tempGestreRecogniser.direction = .left
        return tempGestreRecogniser
    }()

    ///right gesture Recogniser to move page right
    private let rightGestureRecogniser: UISwipeGestureRecognizer = {
        let tempGestreRecogniser = UISwipeGestureRecognizer()
        tempGestreRecogniser.direction = .right
        return tempGestreRecogniser
    }()

    /// GestureRecognizers on menuBackGroundView
    private let dismissMenuGestureRecognisers: [UIGestureRecognizer] = {
        let tapGestreRecogniser = UITapGestureRecognizer()
        let tempGestreRecogniser = UISwipeGestureRecognizer()
        tempGestreRecogniser.direction = .right
        return [tapGestreRecogniser, tempGestreRecogniser]
    }()

    //MARK: - View Data

    ///trailing constraint of next button
    lazy private var nextButtonTrailingConstraint = takeSurveyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: nextButtonWidth)
    lazy private var menuViewTrailingConstraint   = menuView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: menuWidth)
    lazy private var menuBgTrailingConstraint      = menuBackGroundView.trailingAnchor.constraint(equalTo: self.view.leadingAnchor)

    /// width of next button
    private let nextButtonWidth: CGFloat = 56

    ///spacing required for the views for the main view
    private let edgeSpacing: CGFloat = 20

    ///width of the menu
    private let menuWidth: CGFloat = 240

    ///top anchor of view with respect to bezels
    private var safeTopAnchor:NSLayoutYAxisAnchor
    {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.topAnchor
        } else {
            return self.view.topAnchor
        }
    }

    //MARK: - Manager

    ///network layer to fetch surveys
    private let surveyListSessionManager = SurveyListSessionManager()
    ///network layer to fetch image
    private let imageFetchManager = ImageFetcher()
    ///network layer to fetch userDetails
    private let userDetailsFetcher = UserDetailsFetcher()
    ///network layer to logout user
    private let logoutSessionManager = LogoutSessionManager()

    private let surveyDetailFetcher = SurveyDetailFetcher()

    private let authFetcher = AuthTokenFetchManager()

    private let networkDataParser = NetworkDataParser()

    private let viewModel: SurveyListViewModel = SurveyListViewModel()

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //set Views
        view.backgroundColor = .black
        addBackGroundImageView()
        addPageControl()
        addTitleLabel()
        addEnterButton()
        addDescriptionLabel()
        addDateLabel()
        addTodayLabel()
        addProfileButton()
        setMenuView()
        setMenuBackGroundView()

        //make buttons circular
        turnViewIntoCircularView(forView: takeSurveyButton)
        turnViewIntoCircularView(forView: profileButton)

        //show skeleton animation
        view.showSkeletonForSubViews()

        //set gestures
        setGestureRecogniserTargets()
        addPageGestureRecognisers()

        //fetch data
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.fecthDataFromOnline()
        }
    }

    //MARK: - Set GestureRecogniser

    /// sets targets for gesture recognisers
    private func setGestureRecogniserTargets(){
        rightGestureRecogniser.addTarget(self, action: #selector(rightGestureRecogniserCalled))
        leftGestureRecogniser.addTarget(self, action: #selector(leftGestureRecogniserCalled))
        dismissMenuGestureRecognisers.forEach({[weak self] currentGesture in
            guard let weakSelf = self else {return}
            weakSelf.menuBackGroundView.addGestureRecognizer(currentGesture)
            currentGesture.addTarget(weakSelf, action: #selector(hideMenu))
        })
    }
    
    /// add gesture recognisers to view
    private func addPageGestureRecognisers(){
        self.view.addGestureRecognizer(leftGestureRecogniser)
        self.view.addGestureRecognizer(rightGestureRecogniser)
    }

    /// remove gesture recognisers from view
    private func removePageGestureRecognisers(){
        self.view.removeGestureRecognizer(leftGestureRecogniser)
        self.view.removeGestureRecognizer(rightGestureRecogniser)
    }
    
    /// moves page when gesture recogniser is called
    @objc private func leftGestureRecogniserCalled(){
        guard viewModel.numberOfPages > 1,
              viewModel.currentPage < viewModel.numberOfPages - 1 else {
                  return
              }

        changePage(to: viewModel.currentPage + 1)
    }

    /// moves page when gesture recogniser is called
    @objc private func rightGestureRecogniserCalled(){
        guard viewModel.numberOfPages > 1,
              viewModel.currentPage > 0 else {
                  return
              }

        changePage(to: viewModel.currentPage - 1)
    }

    //MARK: - PageControl

    ///do actions when page is changed
    @objc private func pageChanged(){
        changePage(to: pageControl.currentPage)
    }

    /// changes page number
    /// - Parameter pageNumber: page number to be set to
    private func changePage(to pageNumber:Int){
        viewModel.currentPage = pageNumber
        viewModel.pageChanged?()
    }

    //MARK: - DataModel
    ///set's view model to view
    func setViewModel(){

        pageControl.numberOfPages = viewModel.numberOfPages
        dateLabel.changeTextWithanimation(toText: viewModel.dateString)
        todayLabel.changeTextWithanimation(toText: viewModel.todayString)

        if let imageData = viewModel.userImageData{
            UIView.transition(with: self.profileButton,
                              duration: 0.5,
                              options: .transitionCrossDissolve) { [weak self] in
                self?.profileButton.setImage(UIImage(data: imageData), for: .normal)
            }
        }

        viewModel.pageChanged = {
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {return}
                let model = weakSelf.viewModel
                weakSelf.pageControl.currentPage = weakSelf.viewModel.currentPage
                weakSelf.view.layoutIfNeeded()
                let currentPageModel = model.surveys[weakSelf.viewModel.currentPage]
                
                weakSelf.titleLabel.changeTextWithanimation(toText: currentPageModel.title)
                weakSelf.descriptionLabel.changeTextWithanimation(toText: currentPageModel.description)
                if let imgData = currentPageModel.backGroundImageData{
                    weakSelf.backGroundImageView.crossDissolveTransition(toImage: UIImage(data: imgData))
                }
                
            }
        }

        viewModel.pageChanged?()
    }

    //MARK: - Data fetch
    /// fetches data from online
    private func fecthDataFromOnline(){

        let authToken = authFetcher.getToken { [weak self] error in
            self?.handle(tokenGenerationError: error)
        }
        if authToken.isEmpty {return}

        let group = DispatchGroup()
        let group2 = DispatchGroup()

        let errorBlock: ((NetworkCallError)->Void) = { [weak self] error in
            self?.handle(networkCallError: error)
            group.suspend()
        }

        group.enter()

        surveyListSessionManager.getSurveyList(usingAuthToken: authToken, successBlock: { [weak self] surveyList in
            guard let weakSelf = self else {
                group.suspend()
                return
            }
            DispatchQueue.global(qos: .background).async(flags: .barrier) {
                if let pages = surveyList.meta?.pages{
                    weakSelf.viewModel.numberOfPages = pages
                }
            }
            weakSelf.networkDataParser.parse(Data: surveyList) { surveyData in
                group2.enter()
                DispatchQueue.global(qos: .background).async(flags: .barrier) {
                    weakSelf.viewModel.currentPage = 0
                    weakSelf.viewModel.surveys.removeAll()
                    group2.leave()
                }
                group2.wait()
                surveyData.forEach({
                    group2.enter()
                    let newSurvey = SurveyViewVM(fromData: $0)
                    DispatchQueue.global(qos: .background).async(flags: .barrier) {
                        weakSelf.viewModel.surveys.append(newSurvey)
                        group2.leave()
                    }
                    group2.wait()

                    group.enter()
                    weakSelf.imageFetchManager.fetchImage(forURL: $0.attributes.coverImageURL, errorBlock: errorBlock) { imageData in
                        newSurvey.addBackGroundImageData(data: imageData)
                        group.leave()
                    }
                })
                group.leave()
            } errorBlock: { error in
                weakSelf.handle(dataFetchError: error)
                group.suspend()
            }

        }, errorBlock: errorBlock)


        group.enter()

        userDetailsFetcher.fetchUserDetails(usingAuthToken: authToken, successBlock: { [weak self]  userData in
            guard let weakSelf = self else {
                group.suspend()
                return
            }
            weakSelf.networkDataParser.parse(Data: userData) { user in
                group2.enter()
                DispatchQueue.global(qos: .background).async(flags: .barrier) {
                    weakSelf.viewModel.addUserDetails(userData:  user)
                    weakSelf.menuController.viewModel.addUserDetails(userData:  user)
                    group2.leave()
                }
                group2.wait()

                group.enter()
                weakSelf.imageFetchManager.fetchImage(forURL: user.attributes.avatarURL, errorBlock: errorBlock) { imageData in
                    weakSelf.viewModel.addUserImageData(data: imageData)
                    weakSelf.menuController.viewModel.addUserImageData(data: imageData)
                    group.leave()
                }
                group.leave()

            } errorBlock: {error in
                weakSelf.handle(dataFetchError: error)
                group.suspend()
            }

        }, errorBlock: errorBlock)

        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.dismissLoading()
            weakSelf.setViewModel()
            weakSelf.menuController.setViewModel()
        }

    }

    //MARK: - Hud
    func dismissLoading() {
        self.nextButtonTrailingConstraint.constant =  -self.edgeSpacing
        self.view.removeSkeletonAnimationForSubViews()
    }

    //MARK: - Add View

    ///method adds pagecontrol to the view
    private func addPageControl(){
        self.view.addSubview(pageControl)
        pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)

        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -15),
            pageControl.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -edgeSpacing),
            pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -214),
            pageControl.heightAnchor.constraint(equalToConstant: 8)
        ])
    }

    ///adds titleLabel to the view
    private func addTitleLabel(){
        self.view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: edgeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -edgeSpacing),
            titleLabel.topAnchor.constraint(equalTo: self.pageControl.bottomAnchor, constant: 26),
            titleLabel.heightAnchor.constraint(equalToConstant: 68)
        ])
    }

    ///adds descriptionLabel to the view
    private func addDescriptionLabel(){
        self.view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: edgeSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.takeSurveyButton.leadingAnchor, constant: -edgeSpacing),
            descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 42),
            takeSurveyButton.bottomAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor)
        ])
    }

    ///adds dateLabel to the view
    private func addDateLabel(){
        self.view.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: edgeSpacing),
            dateLabel.widthAnchor.constraint(equalToConstant: 200),
            dateLabel.topAnchor.constraint(equalTo: self.safeTopAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    ///adds todayLabel to the view
    private func addTodayLabel(){
        self.view.addSubview(todayLabel)

        NSLayoutConstraint.activate([
            todayLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: edgeSpacing),
            todayLabel.widthAnchor.constraint(equalToConstant: 97),
            todayLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 4),
            todayLabel.heightAnchor.constraint(equalToConstant: 41)
        ])
    }

    ///adds profileButton to the view
    private func addProfileButton(){
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        self.view.addSubview(profileButton)

        NSLayoutConstraint.activate([
            profileButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -edgeSpacing),
            profileButton.widthAnchor.constraint(equalToConstant: 36),
            profileButton.heightAnchor.constraint(equalTo: profileButton.widthAnchor),
            profileButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 79)
        ])
    }

    ///adds addNextButton to the view
    private func addEnterButton(){
        self.view.addSubview(takeSurveyButton)
        takeSurveyButton.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            nextButtonTrailingConstraint,
            takeSurveyButton.widthAnchor.constraint(equalToConstant: nextButtonWidth),
            takeSurveyButton.heightAnchor.constraint(equalTo: takeSurveyButton.widthAnchor),
        ])
    }

    /// method sets menu backGround view
    private func setMenuBackGroundView(){
        self.view.addSubview(menuBackGroundView)

        NSLayoutConstraint.activate([
            nextButtonTrailingConstraint,
            menuBackGroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            menuBackGroundView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            menuBackGroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

        ])
    }

    /// method sets menu view
    private func setMenuView(){

        self.view.addSubview(menuView)

        NSLayoutConstraint.activate([
            menuView.widthAnchor.constraint(equalToConstant: menuWidth),
            menuView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            menuView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            menuViewTrailingConstraint
        ])

        self.view.layoutIfNeeded()

        menuController.delegate = self

        menuController.willMove(toParent: self)
        self.addChild(menuController)
        menuView.addSubview(menuController.view)
        menuController.didMove(toParent: self)

        menuController.view.frame = menuView.bounds
    }

    //MARK: - Button Tapped Actions
    /// calls when enter button is tapped
    @objc func enterButtonTapped(){

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let weakSelf = self else {return}
            let authToken = weakSelf.authFetcher.getToken { [weak self] error in
                weakSelf.handle(tokenGenerationError: error)
            }

            DispatchQueue.main.async { [weak self] in
                weakSelf.showHud()
            }

            let currentModel = weakSelf.viewModel.surveys[weakSelf.viewModel.currentPage]

            guard let surveyID = currentModel.surveyID,
                  !authToken.isEmpty else { return }

            weakSelf.surveyDetailFetcher.getSurveyDetails(usingAuthToken: authToken, forSurveyID: surveyID) { [weak self] surveyDetailData in
                weakSelf.dismissHud()
                DispatchQueue.main.async { [weak self] in
                    let takeSurveyVC = TakeSurveyViewController(surveyViewVMProtocol: currentModel, surveyDetailData: surveyDetailData)
                    takeSurveyVC.modalTransitionStyle = .crossDissolve
                    takeSurveyVC.modalPresentationStyle = .fullScreen
                    weakSelf.present(takeSurveyVC, animated: true)
                }

            } errorBlock: { [weak self] error in
                weakSelf.handle(networkCallError: error)
            }
        }
    }
    
    /// calls when profile button is tapped
    @objc private func profileButtonTapped(){
        removePageGestureRecognisers()
        menuBgTrailingConstraint.isActive = false
        menuBgTrailingConstraint      = menuBackGroundView.trailingAnchor.constraint(equalTo: self.menuView.leadingAnchor)
        menuBgTrailingConstraint.isActive = true
        menuBackGroundView.backgroundColor = .clear
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let weakSelf = self else {return}
            let color: CGFloat = 30/256
            weakSelf.menuBackGroundView.backgroundColor = UIColor(red: color, green: color, blue: color, alpha: 0.45)
            weakSelf.menuViewTrailingConstraint.constant = 0
            weakSelf.view.layoutIfNeeded()
        }
    }
    
    /// method hides menu
    @objc private func hideMenu(){

        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.menuBackGroundView.backgroundColor = .clear
            weakSelf.menuViewTrailingConstraint.constant = weakSelf.menuWidth
            weakSelf.view.layoutIfNeeded()
        }completion: { [weak self] isCompleted in
            guard let weakSelf = self else {return}
            weakSelf.menuBgTrailingConstraint.isActive = false
            weakSelf.menuBgTrailingConstraint      = weakSelf.menuBackGroundView.trailingAnchor.constraint(equalTo: weakSelf.view.leadingAnchor)
            weakSelf.menuBgTrailingConstraint.isActive = true
            weakSelf.view.layoutIfNeeded()
            weakSelf.addPageGestureRecognisers()
        }
    }

    //MARK: - MenuControllerDelegate
    func userDidSelectCell(cell: MenuControllerViewModel.MenuControllerCellType) {
        switch cell{
        case .logout:
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let weakSelf = self else {return}
                weakSelf.logoutSessionManager.logOutUser(forToken: KeyChainManager.shared.getString(forKey: .accessToken))
                KeyChainManager.shared.deleteKeyChainData()
                DispatchQueue.main.async {
                    AppDelegate.shared?.showLoginView(isWithAnimation: false)
                }
            }
            break
        }
    }

}

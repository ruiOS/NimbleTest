//
//  SurveyListViewController.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import UIKit

class SurveyListViewController:UIViewController, LoaderProtocol, ErrorHandleProtocol {

    //MARK: - Views

    ///BackGround imageView
    private let backGroundImageView: UIImageView = {
        let tempImageView = UIImageView()
        tempImageView.translatesAutoresizingMaskIntoConstraints = false
        tempImageView.contentMode = .scaleAspectFill
        tempImageView.backgroundColor = .black
        return tempImageView
    }()

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
        return tempButton
    }()

    ///next button to move to next slide of survey
    private let enterButton: UIButton = {
        let tempButton = UIButton()
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.backgroundColor = .white
        tempButton.isSkeletonEnabled =  true
        tempButton.setImage(UIImage(named: "Arrow"), for: .normal)
        return tempButton
    }()

    //MARK: - View Data

    ///trailing constraint of next button
    lazy private var nextButtonTrailingConstraint = enterButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: nextButtonWidth)

    /// width of next button
    private let nextButtonWidth: CGFloat = 56

    ///spacing required for the views for the main view
    private let edgeSpacing: CGFloat = 20

    ///top anchor of view with respect to bezels
    var safeTopAnchor:NSLayoutYAxisAnchor
    {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.topAnchor
        } else {
            return self.view.topAnchor
        }
    }

    //MARK: - Manager
    private let surveyListSessionManager = SurveyListSessionManager()
    private let imageFetchManager = ImageFetcher()

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

        //make buttons circular
        turnViewIntoCircularView(forView: enterButton)
        turnViewIntoCircularView(forView: profileButton)

        view.showSkeletonForSubViews()

        fecthSurveyData()
    }

    //MARK: - DataModel
    func setDataModel(){

        pageControl.numberOfPages = viewModel.numberOfPages
        dateLabel.text = viewModel.dateString
        todayLabel.text = viewModel.todayString

        viewModel.pageChanged = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {return}
                let model = weakSelf.viewModel
                weakSelf.nextButtonTrailingConstraint.constant = model.isLastPage ? weakSelf.nextButtonWidth :  -weakSelf.edgeSpacing
                weakSelf.view.layoutIfNeeded()


                let currentPageModel = model.surveys[weakSelf.viewModel.currentPage]
                if let imgData = currentPageModel.backGroundImageData{
                    print("is image data present")
                    weakSelf.backGroundImageView.image = UIImage(data: imgData)
                }
                print("checked image data present")
                weakSelf.titleLabel.text = currentPageModel.title
                weakSelf.descriptionLabel.text = currentPageModel.description
            }
        }

        viewModel.pageChanged?()
    }

    func fecthSurveyData(){
        let group = DispatchGroup()
        let group2 = DispatchGroup()

        group.enter()

        surveyListSessionManager.getSurveyDetails { [weak self] data in

            group2.enter()
            guard let weakSelf = self else {return}
            DispatchQueue.global(qos: .background).async(flags: .barrier) {
                weakSelf.viewModel.currentPage = 0
                if let pages = data.meta?.pages{
                    weakSelf.viewModel.numberOfPages = pages
                }
                weakSelf.viewModel.surveys.removeAll()
                group2.leave()
            }
            group2.wait()

            data.data?.forEach({
                group2.enter()
                let newSurvey = SurveyViewVM(fromData: $0)
                DispatchQueue.global(qos: .background).async(flags: .barrier) {
                    weakSelf.viewModel.surveys.append(newSurvey)
                    group2.leave()
                }
                group2.wait()
                group.enter()
                weakSelf.imageFetchManager.fetchImage(forURL: $0.attributes.coverImageURL) { error in
                    weakSelf.handle(error: error)
                    group.suspend()
                } completionBlock: { data in
                    newSurvey.addBackGroundImageData(data: data)
                    group.leave()
                    
                }
            })
            group.leave()
        } errorBlock: { [weak self] error in
            self?.handle(error: error)
            group.suspend()
        }

        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.dismissLoading()
            weakSelf.setDataModel()
        }

    }

    //MARK: - Hud
    func dismissLoading() {
        self.view.removeSkeletonAnimationForSubViews()
    }

    //MARK: - Add View

    ///method adds backGroundImageView to the view
    private func addBackGroundImageView(){
        self.view.addSubview(backGroundImageView)

        NSLayoutConstraint.activate([
            backGroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backGroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            backGroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backGroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    ///method adds pagecontrol to the view
    private func addPageControl(){
        self.view.addSubview(pageControl)

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
            descriptionLabel.trailingAnchor.constraint(equalTo: self.enterButton.leadingAnchor, constant: -edgeSpacing),
            descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 42),
            enterButton.bottomAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor)
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
        self.view.addSubview(profileButton)

        NSLayoutConstraint.activate([
            profileButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -edgeSpacing),
            profileButton.widthAnchor.constraint(equalToConstant: 36),
            profileButton.heightAnchor.constraint(equalTo: profileButton.heightAnchor),
            profileButton.bottomAnchor.constraint(equalTo: self.todayLabel.bottomAnchor, constant: 0)
        ])
    }

    ///adds addNextButton to the view
    private func addEnterButton(){
        self.view.addSubview(enterButton)
        enterButton.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            nextButtonTrailingConstraint,
            enterButton.widthAnchor.constraint(equalToConstant: nextButtonWidth),
            enterButton.heightAnchor.constraint(equalTo: enterButton.widthAnchor),
        ])
    }

    @objc func enterButtonTapped(){
        
    }
    
    /// makes given view circular
    /// - Parameter circularView: view to be turned circular
    private func turnViewIntoCircularView(forView circularView: UIView){
        self.view.layoutIfNeeded()
        circularView.layer.cornerRadius = circularView.frame.size.width/2
        circularView.clipsToBounds = true
    }
}

//
//  SurveyListViewController.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import UIKit

class SurveyListViewController:UIViewController{

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
    private let nextButton: UIButton = {
        let tempButton = UIButton()
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.backgroundColor = .white
        tempButton.isSkeletonEnabled =  true
        tempButton.setImage(UIImage(named: "Arrow"), for: .normal)
        return tempButton
    }()

    //MARK: - View Data

    ///trailing constraint of next button
    lazy private var nextButtonTrailingConstraint = nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: nextButtonWidth)

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
    let surveyListSessionManager = SurveyListSessionManager()

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //set Views
        view.backgroundColor = .black
        addBackGroundImageView()
        addPageControl()
        addTitleLabel()
        addNextButton()
        addDescriptionLabel()
        addDateLabel()
        addTodayLabel()
        addProfileButton()

        //make buttons circular
        turnViewIntoCircularView(forView: nextButton)
        turnViewIntoCircularView(forView: profileButton)

        view.showSkeletonForSubViews()

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

        pageControl.numberOfPages = 3
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
            descriptionLabel.trailingAnchor.constraint(equalTo: self.nextButton.leadingAnchor, constant: -edgeSpacing),
            descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 42),
            nextButton.bottomAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor)
        ])
    }

    ///adds dateLabel to the view
    private func addDateLabel(){
        self.view.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: edgeSpacing),
            dateLabel.widthAnchor.constraint(equalToConstant: 117),
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
    private func addNextButton(){
        self.view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            nextButtonTrailingConstraint,
            nextButton.widthAnchor.constraint(equalToConstant: nextButtonWidth),
            nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor),
        ])
    }
    
    /// makes given view circular
    /// - Parameter circularView: view to be turned circular
    private func turnViewIntoCircularView(forView circularView: UIView){
        self.view.layoutIfNeeded()
        circularView.layer.cornerRadius = circularView.frame.size.width/2
        circularView.clipsToBounds = true
    }
}

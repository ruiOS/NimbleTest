//
//  TakeSurveyViewController.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import UIKit

class TakeSurveyViewController: NimbleViewController, CircleViewProtocol {

    private let backButton: UIButton = {
        let tempButton = UIButton()
        tempButton.backgroundColor = .clear
        tempButton.setImage(UIImage(named: "navigationArrow"), for: .normal)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        return tempButton
    }()

    private let closeSurveyButton: UIButton = {
        let tempButton = UIButton()
        tempButton.backgroundColor = .clear
        tempButton.setImage(UIImage(named: "closeIcon"), for: .normal)
        tempButton.titleLabel?.font = UIFont.descriptionLabelFont
        tempButton.backgroundColor = UIColor(white: 1, alpha: 0.2)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        tempButton.isHidden = true
        return tempButton
    }()

    private let takeSurveyButton: UIButton = {
        let tempButton = UIButton()
        tempButton.backgroundColor = .clear
        tempButton.setTitle(AppStrings.surveyDetailView_today, for: .normal)
        tempButton.backgroundColor = UIColor.white
        tempButton.setTitleColor(.black, for: .normal)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        return tempButton
    }()

    private let introView: TakeSurveyIntroView = {
        let tempView = TakeSurveyIntroView()
        tempView.backgroundColor = .clear
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()

    private let viewModel: TakeSurveyViewModel
    private lazy var introViewTrailingConstraint = introView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)

    /*
    private let surveyCollectionView: UICollectionView = {
        let tempView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        tempView.backgroundColor = .clear
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()
     */

    convenience init(surveyViewVMProtocol: SurveyViewVMProtocol, surveyDetailData: SurveyDetailDataModel) {
        let viewModel = TakeSurveyViewModel(surveyViewVMProtocol: surveyViewVMProtocol, surveyDetailData: surveyDetailData)
        self.init(viewModel: viewModel)
    }

    init(viewModel: TakeSurveyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackGroundImageView(asZoomIn: true)
        setBackButton()
        setCloseSurveyButton()
        addTakeSurveyButton()
        setIntroView()
    }

    private func setBackButton(){
        self.view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        let backButtonTopAnchor: NSLayoutConstraint = {
            if #available(iOS 11.0, *) {
                return backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25)
            }else{
                return backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25)
            }}()

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 22),
            backButtonTopAnchor,
            backButton.heightAnchor.constraint(equalToConstant: 20.5),
            backButton.widthAnchor.constraint(equalToConstant: 12),
        ])
    }

    private func addTakeSurveyButton(){
        self.view.addSubview(takeSurveyButton)
        takeSurveyButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            takeSurveyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            takeSurveyButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -54),
            takeSurveyButton.heightAnchor.constraint(equalToConstant: 56),
            takeSurveyButton.widthAnchor.constraint(equalToConstant: 140),
        ])

        self.view.layoutIfNeeded()
        takeSurveyButton.layer.cornerRadius = 10
        takeSurveyButton.clipsToBounds = true
    }

    private func setCloseSurveyButton(){
        self.view.addSubview(closeSurveyButton)
        closeSurveyButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        let closeSurveyButtonTopAnchor: NSLayoutConstraint = {
            if #available(iOS 11.0, *) {
                return closeSurveyButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24.34)
            }else{
                return closeSurveyButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24.34)
            }}()

        NSLayoutConstraint.activate([
            closeSurveyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            closeSurveyButtonTopAnchor,
            closeSurveyButton.heightAnchor.constraint(equalToConstant: 28),
            closeSurveyButton.widthAnchor.constraint(equalToConstant: 28),
        ])
        turnViewIntoCircularView(forView: closeSurveyButton)
    }

    private func setIntroView(){
        self.view.addSubview(introView)
        introView.viewModel = TakeSurveyIntroVM(title: viewModel.title, subTitle: viewModel.description)

        NSLayoutConstraint.activate([
            introView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            introViewTrailingConstraint,
            introView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            introView.topAnchor.constraint(equalTo: self.backButton.bottomAnchor)

        ])
    }

    override func addBackGroundImageView(asZoomIn isZoomIn: Bool = false) {
        super.addBackGroundImageView(asZoomIn: isZoomIn)
        if let imgData = viewModel.backGroundImageData{
            self.backGroundImageView.image = UIImage(data: imgData)
        }
    }

    @objc private func backButtonPressed(){
        self.dismiss(animated: true)
    }

}

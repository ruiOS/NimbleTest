//
//  SurveyView.swift
//  NimbleTest
//
//  Created by rupesh on 29/03/22.
//

import UIKit

class SurveyView: UIView{

    private let leadingSpacing: CGFloat = 20
    private let trailingSpacing: CGFloat = 24

    private let pageNumberLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = .clear
        tempLabel.font = UIFont.pageNumberLabelFont
        tempLabel.contentMode = .topLeft
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }()

    private let questionLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = .clear
        tempLabel.font = UIFont.todayLabelFont
        tempLabel.contentMode = .topLeft
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }()

    private let answerView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = .yellow
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addPageLabel()
        addQuestionLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addPageLabel(){
        self.addSubview(pageNumberLabel)
        NSLayoutConstraint.activate([
            pageNumberLabel.heightAnchor.constraint(equalToConstant: 20),
            pageNumberLabel.widthAnchor.constraint(equalToConstant: 23),
            pageNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            pageNumberLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }

    private func addQuestionLabel(){
        self.addSubview(questionLabel)
        NSLayoutConstraint.activate([
            questionLabel.heightAnchor.constraint(equalToConstant: 123),
            questionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingSpacing),
            questionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -leadingSpacing),
            questionLabel.topAnchor.constraint(equalTo: pageNumberLabel.bottomAnchor, constant: 8)
        ])
    }

    private func addAnswerView(){
        self.addSubview(answerView)
        NSLayoutConstraint.activate([
            answerView.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor, constant: -140),
            answerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            answerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            answerView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, constant: -45)
        ])
    }
    
}

//
//  TakeSurveyIntroView.swift
//  NimbleTest
//
//  Created by rupesh on 29/03/22.
//

import UIKit

class TakeSurveyIntroView:UIView{

    private let spacing: CGFloat = 21

    private let titleLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = .clear
        tempLabel.font = UIFont.todayLabelFont
        tempLabel.contentMode = .topLeft
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }()

    private let subTitleLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = .clear
        tempLabel.font = UIFont.descriptionLabelFont
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.contentMode = .topLeft
        return tempLabel
    }()

    var viewModel: TakeSurveyIntroVM? = nil{
        didSet{
            self.titleLabel.text = viewModel?.title
            self.subTitleLabel.text = viewModel?.subTitle
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addTitleLabel()
        addSubTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addTitleLabel(){
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 82),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ])
    }

    private func addSubTitleLabel(){
        self.addSubview(subTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.heightAnchor.constraint(equalToConstant: 42),
            subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spacing),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spacing),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
        ])
    }
}

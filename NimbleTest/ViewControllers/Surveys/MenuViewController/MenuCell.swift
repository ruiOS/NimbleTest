//
//  MenuCell.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import UIKit

class MenuCell: UITableViewCell{

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// method sets colors for required subviews
    private func setViewColors(){
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .default

        let view = UIView()
        view.backgroundColor = UIColor(white: 0.2, alpha: 0.5)
        self.selectedBackgroundView = view
    }

    //MARK: - Set Data
    /// methid sets text to cell
    /// - Parameter text: text to be set
    func set(text: String){
        textLabel?.text = text
        textLabel?.contentMode = .left
        textLabel?.font = UIFont.menuCellTitleFont
    }

    //MARK: - View Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.text = nil
    }

}

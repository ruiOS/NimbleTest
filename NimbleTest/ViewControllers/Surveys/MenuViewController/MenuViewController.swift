//
//  MenuViewController.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import UIKit

///Menu controller to display profile menu items
class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CircleViewProtocol{

    //MARK: - Views

    ///View Consisting of profile details of the user
    private let profileView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = .clear
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()

    ///View Consisting of image of the user
    private let profilePicImageView: UIImageView = {
        let tempImageView = UIImageView()
        tempImageView.backgroundColor = .clear
        tempImageView.image = UIImage(named: "Oval")
        tempImageView.contentMode = .scaleAspectFit
        tempImageView.translatesAutoresizingMaskIntoConstraints = false
        return tempImageView
    }()

    ///View Consisting of userName of the user
    private let userNameLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = .clear
        tempLabel.textColor = .white
        tempLabel.contentMode = .topLeft
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.minimumScaleFactor = 0.5
        tempLabel.font = UIFont.todayLabelFont
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }()

    ///Seperator View between menu and profile view
    private let separatorView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor(white: 0.5, alpha: 1)
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()

    ///fooetr label of version
    private let versionLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.backgroundColor = .clear
        tempLabel.textColor = .white
        tempLabel.contentMode = .topLeft
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.minimumScaleFactor = 0.5
        tempLabel.font = UIFont.versionLabelFont
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }()

    ///table view consisiting of menu actions
    private let tableView: UITableView = {
        let tempTableView = UITableView()
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.backgroundColor = .clear
        tempTableView.separatorStyle = .none
        tempTableView.isScrollEnabled = false
        return tempTableView
    }()

    //MARK: - Data

    ///spacing for the views
    private let spacing: CGFloat = 20

    /// MenuControllerDelegate to handle operations
    var delegate: MenuControllerDelegate?

    ///view model of the menu
    var viewModel: MenuControllerViewModel = MenuControllerViewModel()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let colorValue: CGFloat = 30/256
        self.view.backgroundColor = UIColor(red: colorValue, green: colorValue, blue: colorValue, alpha: 0.9)

        addProfileView()
        addSeperator()
        addVersionLabel()
        addTableView()
        setViewModel()
    }

    //MARK: - Data model
    /// method sets  view model to the view
    func setViewModel(){
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {return}
            weakSelf.versionLabel.text = weakSelf.viewModel.version
            if let imgData = weakSelf.viewModel.userImageData{
                weakSelf.profilePicImageView.image = UIImage(data: imgData)
            }
            weakSelf.userNameLabel.text = weakSelf.viewModel.userName
            weakSelf.tableView.reloadData()
        }
    }

    //MARK: - Add views
    
    /// adds profile image to View
    private func addProfileView(){

        self.view.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.heightAnchor.constraint(equalToConstant: 140),
            profileView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            profileView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            profileView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])

        profileView.addSubview(profilePicImageView)
        NSLayoutConstraint.activate([
            profilePicImageView.heightAnchor.constraint(equalToConstant: 36),
            profilePicImageView.widthAnchor.constraint(equalTo: profilePicImageView.heightAnchor),
            profilePicImageView.trailingAnchor.constraint(equalTo: self.profileView.trailingAnchor, constant: -spacing),
            profilePicImageView.topAnchor.constraint(equalTo: self.profileView.topAnchor, constant: 79)
        ])
        turnViewIntoCircularView(forView: profilePicImageView)

        profileView.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.heightAnchor.constraint(equalToConstant: 41),
            userNameLabel.trailingAnchor.constraint(equalTo: profilePicImageView.leadingAnchor, constant: -spacing),
            userNameLabel.leadingAnchor.constraint(equalTo: self.profileView.leadingAnchor, constant: spacing),
            userNameLabel.topAnchor.constraint(equalTo: self.profileView.topAnchor, constant: 80)
        ])
    }

    /// adds separator to View
    private func addSeperator(){
        self.view.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: spacing),
            separatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -spacing),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.topAnchor.constraint(equalTo: self.profileView.bottomAnchor)
        ])
    }

    /// adds versionLabel to View
    private func addVersionLabel(){
        self.view.addSubview(versionLabel)
        NSLayoutConstraint.activate([
            versionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: spacing),
            versionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -spacing),
            versionLabel.heightAnchor.constraint(equalToConstant: 13),
            versionLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -spacing)
        ])
    }

    /// adds tableView to View
    private func addTableView(){

        self.view.addSubview(tableView)

        tableView.register(MenuCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: spacing),
            tableView.bottomAnchor.constraint(equalTo: self.versionLabel.topAnchor)
        ])
    }

    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.cells.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MenuCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MenuCell else {
                return MenuCell(style: .default, reuseIdentifier: "Cell")
            }
            return cell
        }()

        switch viewModel.cells[indexPath.row]{
        case .logout:
            cell.set(text: AppStrings.common_logout)
        }
        return cell
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.userDidSelectCell(cell:viewModel.cells[indexPath.row])
    }

}

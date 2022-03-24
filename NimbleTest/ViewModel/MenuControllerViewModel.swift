//
//  MenuControllerViewModel.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

class MenuControllerViewModel: UserViewModelProtocol{

    var userName:String = ""
    var userImageData: Data?

    ///version number of app
    let version: String = {
        guard let infoDictionary = Bundle.main.infoDictionary else { return "" }
        func getStringFor(optionalString: String?)->String{
            guard let tempString = optionalString else { return "" }
            return tempString
        }
        return "v\(getStringFor(optionalString: infoDictionary["CFBundleShortVersionString"] as? String))(\(getStringFor(optionalString: infoDictionary["CFBundleVersion"] as? String)))"
    }()

    enum MenuControllerCellType: Int{
        case logout
    }

    var cells = [MenuControllerCellType.logout]
}

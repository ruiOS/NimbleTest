//
//  UserViewModelProtocol.swift
//  NimbleTest
//
//  Created by rupesh on 24/03/22.
//

import Foundation

///confirm to view models that display user data
protocol UserViewModelProtocol: AnyObject{
    var userName: String {get set}
    var userImageData: Data? { get set}
}

extension UserViewModelProtocol{
    func addUserImageData(data: Data){
        DispatchQueue.global(qos: .background).async(flags: .barrier){[weak self] in
            self?.userImageData = data
        }
    }

    func addUserDetails(userData: User){
        DispatchQueue.global(qos: .background).async(flags: .barrier){[weak self] in
            self?.userName = userData.attributes.name
        }
    }
}

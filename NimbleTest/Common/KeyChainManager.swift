//
//  KeyChainManager.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation
import SwiftKeychainWrapper

///querys from keychain
public enum KeychainQuery:String {
    case keyVersion
    case accessToken
    case refreshToken
    case tokenCreationTime
    case tokenExpiryPeriod
}

///Singleton operates all data in keychain
struct KeyChainManager{

    //MARK: - Singleton

    ///static object of KeyChainManager
    static let shared: KeyChainManager = KeyChainManager()

    private init(){}

    ///keychain wrapper for the app
    private let wrapper = KeychainWrapper(serviceName: "NimbleTest")

    //MARK: - Save
    
    /// Method adds data to keychain usin KeyChainJsonClass
    /// - Parameter keyChainData: KeyChainJsonClass which need to be stored in keychain
    func save(keyChainData: KeyChainJsonClass){
        save(integer: 1, key: .keyVersion)
        save(integer: keyChainData.createdAt, key: .tokenCreationTime)
        save(integer: keyChainData.expiresIn, key: .tokenExpiryPeriod)
        save(string: keyChainData.accessToken, forKey: .accessToken)
        save(string: keyChainData.refreshToken, forKey: .refreshToken)
    }
    
    /// Saves string for the given key
    /// - Parameters:
    ///   - string: string to be stored
    ///   - key: key of the query
    public func save(string: String?,forKey key: KeychainQuery){
        if let tempString = string, !tempString.isEmpty{
            wrapper.set(tempString, forKey: key.rawValue)
        }
    }
    
    /// Saves Integer for the given key
    /// - Parameters:
    ///   - integer: integer to be stored
    ///   - key: key of the query
    public func save(integer: Int, key: KeychainQuery){
        wrapper.set(integer, forKey: key.rawValue)
    }

    //MARK: - Read

    /// returns string for the given query
    /// - Parameter key: key of the query
    /// - Returns: string for the query
    func getString(forKey key: KeychainQuery)->String?{
        return wrapper.string(forKey: key.rawValue)
    }
    
    /// returns integer for the given query
    /// - Parameter key: key of the query
    /// - Returns: integer for the query
    func getInteger(forKey key: KeychainQuery)->Int?{
        return wrapper.integer(forKey: key.rawValue)
    }

    //MARK: - Remove
    /// remove data for a query in keychain
    /// - Parameter key: query for which data need to be removed
    public func removeObject(forKey key: KeychainQuery){
        wrapper.removeObject(forKey: key.rawValue)
    }
    
    /// deletes all app data in keychain
    public func deleteKeyChainData(){
        let keys = wrapper.allKeys()
        for aKey in keys{
            wrapper.removeObject(forKey: aKey)
        }
    }

}

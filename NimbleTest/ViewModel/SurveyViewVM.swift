//
//  SurveyViewVM.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import Foundation

protocol SurveyViewVMProtocol{
    var backGroundImageData: Data? {get set}

    var title: String? {get set}

    var description: String? {get set}

    var surveyID: String? {get set}
}

class SurveyViewVM: SurveyViewVMProtocol{

    var backGroundImageData: Data?

    var title: String?

    var description: String?

    var surveyID: String?

    init(fromData data: SurveyData){
        DispatchQueue.global(qos: .background).async(flags: .barrier){[weak self] in
            guard let weakSelf = self else {return}
            weakSelf.title = data.attributes.title
            weakSelf.description = data.attributes.attributesDescription
            weakSelf.surveyID = data.id
        }
    }

    func addBackGroundImageData(data: Data){
        DispatchQueue.global(qos: .background).async(flags: .barrier){[weak self] in
            self?.backGroundImageData = data
        }
    }

}

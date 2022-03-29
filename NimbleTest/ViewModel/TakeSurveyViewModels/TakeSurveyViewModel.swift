//
//  TakeSurveyViewModel.swift
//  NimbleTest
//
//  Created by rupesh on 29/03/22.
//

import Foundation

class TakeSurveyViewModel: SurveyViewVMProtocol{

    var backGroundImageData: Data?
    var title: String?
    var description: String?
    var surveyID: String?

    var questions: Questions?

    init(surveyViewVMProtocol: SurveyViewVMProtocol, surveyDetailData: SurveyDetailDataModel){
        self.backGroundImageData = surveyViewVMProtocol.backGroundImageData
        self.title = surveyViewVMProtocol.title
        self.description = surveyViewVMProtocol.description
        self.surveyID = surveyViewVMProtocol.surveyID

        self.questions = surveyDetailData.data?.relationships.questions
    }
}

//
//  SurveyListViewModel.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import Foundation

///ViewModel for Survey List View Controller
class SurveyListViewModel{

    ///string today localised
    let todayString = AppStrings.surveyView_today

    ///dateString of today's date
    var dateString: String  = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM, dd"
        return dateFormatter.string(from: Date())
    }()

    
}

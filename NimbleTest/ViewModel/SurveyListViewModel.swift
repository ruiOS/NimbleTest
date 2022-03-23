//
//  SurveyListViewModel.swift
//  NimbleTest
//
//  Created by rupesh on 22/03/22.
//

import Foundation

///ViewModel for Survey List View Controller
class SurveyListViewModel{

    var surveys = [SurveyViewVM]()

    var numberOfPages: Int = 0

    var currentPage:Int = 0

    ///string today localised
    let todayString = AppStrings.surveyView_today

    ///dateString of today's date
    var dateString: String  = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM, dd"
        return dateFormatter.string(from: Date())
    }()

    var profileImage: Data?

    var pageChanged:(()->Void)?

    var isLastPage: Bool {
        currentPage == numberOfPages-1
    }

}

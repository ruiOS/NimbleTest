//
//  SurveyList.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

///JSON Data model of survey list
struct SurveyList: Codable {
    let data: [SurveyData]?
    let meta: Meta?
    let errors: [ErrorModel]?

    // MARK: - Meta
    struct Meta: Codable {
        let page, pages, pageSize, records: Int

        enum CodingKeys: String, CodingKey {
            case page, pages
            case pageSize = "page_size"
            case records
        }
    }

}

// MARK: - SurveyData
///Details of the survey
struct SurveyData: Codable {
    let id, type: String
    let attributes: Attributes
    let relationships: Relationships

    // MARK: - Attributes
    struct Attributes: Codable {
        let title, attributesDescription: String
        let thankEmailAboveThreshold, thankEmailBelowThreshold: String?
        let isActive: Bool
        let coverImageURL: String
        let createdAt, activeAt: String
        let inactiveAt: Int?
        let surveyType: String

        enum CodingKeys: String, CodingKey {
            case title
            case attributesDescription = "description"
            case thankEmailAboveThreshold = "thank_email_above_threshold"
            case thankEmailBelowThreshold = "thank_email_below_threshold"
            case isActive = "is_active"
            case coverImageURL = "cover_image_url"
            case createdAt = "created_at"
            case activeAt = "active_at"
            case inactiveAt = "inactive_at"
            case surveyType = "survey_type"
        }
    }

    // MARK: - Relationships
    struct Relationships: Codable {
        let questions: Questions
    }

    // MARK: - Questions
    struct Questions: Codable {
        let data: [QuestionsDatum]
    }

    // MARK: - QuestionsDatum
    struct QuestionsDatum: Codable {
        let id: String
        let type: TypeEnum
    }

    enum TypeEnum: String, Codable {
        case question = "question"
    }

}

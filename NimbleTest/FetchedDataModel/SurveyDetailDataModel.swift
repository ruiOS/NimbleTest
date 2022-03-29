//
//  SurveyDetailDataModel.swift
//  NimbleTest
//
//  Created by rupesh on 28/03/22.
//

import Foundation

// MARK: - Welcome
struct SurveyDetailDataModel: Codable, ResponseDataProtocol {

    var data: SurveyDetailData?
    var errors: [ErrorModel]?
    var included: [Included]?
}

// MARK: - DataClass
struct SurveyDetailData: Codable {
    let id, type: String
    let attributes: DataAttributes
    let relationships: DataRelationships
}

// MARK: - DataAttributes
struct DataAttributes: Codable {
    let title, attributesDescription, thankEmailAboveThreshold, thankEmailBelowThreshold: String
    let isActive: Bool
    let coverImageURL: String
    let createdAt, activeAt: String
    let inactiveAt: JSONNull?
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

// MARK: - DataRelationships
struct DataRelationships: Codable {
    let questions: Questions
}

// MARK: - Questions
struct Questions: Codable {
    let questionData: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id: String
    let type: TypeEnum
}

enum TypeEnum: String, Codable {
    case answer = "answer"
    case question = "question"
}

// MARK: - Included
struct Included: Codable {
    let id: String
    let type: TypeEnum
    let attributes: IncludedAttributes
    let relationships: IncludedRelationships?
}

// MARK: - IncludedAttributes
struct IncludedAttributes: Codable {
    let text, helpText: String?
    let displayOrder: Int
    let shortText: String
    let pick: Pick?
    let displayType: String?
    let isMandatory: Bool
    let correctAnswerID: JSONNull?
    let facebookProfile: String?
    let twitterProfile: JSONNull?
    let imageURL: String?
    let coverImageURL: String?
    let coverImageOpacity: Double?
    let coverBackgroundColor: JSONNull?
    let isShareableOnFacebook, isShareableOnTwitter: Bool?
    let fontFace, fontSize: JSONNull?
    let tagList: String?
    let inputMaskPlaceholder: String?
    let isCustomerFirstName, isCustomerLastName, isCustomerTitle, isCustomerEmail: Bool?
    let promptCustomAnswer: Bool?
    let weight: JSONNull?
    let inputMask: String?
    let dateConstraint, defaultValue: JSONNull?
    let responseClass: ResponseClass?
    let referenceIdentifier: JSONNull?
    let score: Int?
    let alerts: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case text
        case helpText = "help_text"
        case displayOrder = "display_order"
        case shortText = "short_text"
        case pick
        case displayType = "display_type"
        case isMandatory = "is_mandatory"
        case correctAnswerID = "correct_answer_id"
        case facebookProfile = "facebook_profile"
        case twitterProfile = "twitter_profile"
        case imageURL = "image_url"
        case coverImageURL = "cover_image_url"
        case coverImageOpacity = "cover_image_opacity"
        case coverBackgroundColor = "cover_background_color"
        case isShareableOnFacebook = "is_shareable_on_facebook"
        case isShareableOnTwitter = "is_shareable_on_twitter"
        case fontFace = "font_face"
        case fontSize = "font_size"
        case tagList = "tag_list"
        case inputMaskPlaceholder = "input_mask_placeholder"
        case isCustomerFirstName = "is_customer_first_name"
        case isCustomerLastName = "is_customer_last_name"
        case isCustomerTitle = "is_customer_title"
        case isCustomerEmail = "is_customer_email"
        case promptCustomAnswer = "prompt_custom_answer"
        case weight
        case inputMask = "input_mask"
        case dateConstraint = "date_constraint"
        case defaultValue = "default_value"
        case responseClass = "response_class"
        case referenceIdentifier = "reference_identifier"
        case score, alerts
    }

    enum DisplayType:String, Codable{
        case star
        case heart
        case smiley
        case choice
        case intro
        case nps
        case `default`
    }
}

enum Pick: String, Codable {
    case any = "any"
    case none = "none"
    case one = "one"
}

enum ResponseClass: String, Codable {
    case answer = "answer"
    case string = "string"
    case text = "text"
}

// MARK: - IncludedRelationships
struct IncludedRelationships: Codable {
    let answers: Questions
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

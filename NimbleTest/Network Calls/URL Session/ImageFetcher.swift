//
//  ImageFetcher.swift
//  NimbleTest
//
//  Created by rupesh on 23/03/22.
//

import Foundation

struct ImageFetcher: CreateURLRequestProtocol{

    /// method fetches image for given url
    /// - Parameters:
    ///   - urlString: url dtring of the image
    ///   - errorBlock: error block executes when error is thrown
    ///   - completionBlock: completion block on fetching image
    func fetchImage(forURL urlString: String, isHighQualityImageRequored: Bool = true, errorBlock: @escaping ErrorHandleBlock, completionBlock: @escaping ((Data)->Void)){

        let appendStringForURL = isHighQualityImageRequored ? "l" : ""

        guard let url = URL(string: urlString + appendStringForURL) else {return}
        let urlRequest = createURLRequest(withurl: url, withHTTPMethod: .get)

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            if let error = error {
                errorBlock(.serverSideError(error.localizedDescription))
            }else if let data = data,
                     !data.isEmpty{
                completionBlock(data)
            }else{
                errorBlock(.noDataPresent)
            }
        }
        dataTask.resume()
    }
}

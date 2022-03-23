//
//  ImageFetcher.swift
//  NimbleTest
//
//  Created by rupesh-6878 on 23/03/22.
//

import Foundation

class ImageFetcher: CreateURLRequestProtocol{

    func fetchImage(forURL urlString: String, errorBlock: @escaping ErrorHandleBlock, completionBlock: @escaping ((Data)->Void)){
        guard let url = URL(string: urlString) else {return}
        let urlRequest = createURLRequest(withurl: url, withHTTPMethod: .get)

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            if let error = error {
                errorBlock(.serverSideError(error.localizedDescription))
            }else if let data = data,
                     !data.isEmpty{
                completionBlock(data)
            }else{
                errorBlock(.generalError)
            }
        }
        dataTask.resume()
    }
}

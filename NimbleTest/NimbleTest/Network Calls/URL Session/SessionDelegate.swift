//
//  SessionDelegate.swift
//  NimbleTest
//
//  Created by rupesh on 21/03/22.
//

import Foundation

///Common URLSessionDelegate to handle ssl Pinning
class SSLPinningDelegate: NSObject, URLSessionDelegate{

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
           challenge.protectionSpace.host == "survey-api.nimblehq.co" {

            if let pem = Bundle.main.url(forResource:"sni.cloudflaressl.com", withExtension: "cer"),
               let data = NSData(contentsOf: pem),
               let cert = SecCertificateCreateWithData(nil, data) {
                let certs = [cert]
                SecTrustSetAnchorCertificates(serverTrust, certs as CFArray)
                var result=SecTrustResultType.invalid
                if SecTrustEvaluate(serverTrust,&result)==errSecSuccess {
                    if result==SecTrustResultType.proceed || result==SecTrustResultType.unspecified {
                        let proposedCredential = URLCredential(trust: serverTrust)
                        completionHandler(.useCredential,proposedCredential)
                        return
                    }
                }
                
            }
        }
        completionHandler(.performDefaultHandling, nil)
    }

}

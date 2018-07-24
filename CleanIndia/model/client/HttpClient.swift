//
/*
HttpClient.swift
Created on: 7/18/18

Abstract:
 use this class when communicating with Http connections.

*/

import Foundation

typealias toiletCompletionHandler = (_ results: [Toilet], _ error: Error?) -> Void

final class HttpClient: NSObject {
    
    // MARK: properties
    // PUBLIC
    
    /// use this when accessing the httpclient
    public static var shared: HttpClient {
        return client
    }
    
    // PRIVATE
    private static var client: HttpClient {
        return HttpClient()
    }
    
    public func getToilets(latitude: Double,
                           longitude: Double,
                           radius: Double,
                           completion: @escaping toiletCompletionHandler) {
        
        let url = placesURL(HttpConstants.TextSearch.queryValue,
                            latitude: latitude,
                            longitude: longitude,
                            radius: radius)
        guard url != nil else {
            return
        }
        
        getPlaces(url!, completion: completion)
    }
}

private extension HttpClient {
    func getPlaces(_ url: URL, completion: @escaping toiletCompletionHandler) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let code = (response as? HTTPURLResponse)?.statusCode, code >= 200 && code <= 299 else {
                print("status code is not in success range")
                return
            }
            
            guard data != nil else {
                print("Data is empty")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            let toilets = try? jsonDecoder.decode(Toilets.self, from: data!)
            completion((toilets?.results ?? []), nil)
            
        }.resume()
    }
    
    func placesURL(_ query: String, latitude: Double, longitude: Double, radius: Double) -> URL? {
        let uri = "\(HttpConstants.baseURL)\(HttpConstants.TextSearch.method)\(HttpConstants.outputFormat)?"
        let query = "\(HttpConstants.TextSearch.ParameterKey.query)=\(query)&" +
            "\(HttpConstants.TextSearch.ParameterKey.apiKey)=\(HttpConstants.API_KEY)&" +
            "\(HttpConstants.TextSearch.ParameterKey.location)=\(latitude),\(longitude)&" +
            "\(HttpConstants.TextSearch.ParameterKey.radius)=\(radius)"
        let url = uri + query
        return URL(string: url)
    }
}

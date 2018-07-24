//
/*
HttpConstants.swift
Created on: 7/18/18

Abstract:
 all the http related constants are written inside this method

*/

import Foundation

struct HttpConstants {
    static let baseURL = "https://maps.googleapis.com/maps/api/"
    static let outputFormat = "json"
    static let API_KEY = "API_KEY"
    
    struct TextSearch {
        static let method = "place/textsearch/"
        static let queryValue = "toilet+kerala"
        struct ParameterKey {
            static let query = "query"
            static let apiKey = "key"
            static let location = "location"
            static let radius = "radius"
        }
    }
}

//
/*
Store.swift
Created on: 7/23/18

Abstract:
 It includes the shared data

*/

import Foundation

final class Store: NSObject {
    private static let instance = Store()
    
    public static var shared: Store {
        return instance
    }
    
    public var toilets = [Toilet]()
}

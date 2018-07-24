//
/*
Overlay.swift
Created on: 7/24/18

Abstract:
 this class will help in showing the overlay with an acitivity indicator.

*/

import UIKit

final class Overlay: NSObject {
    private static let instance = Overlay()
    public static var shared: Overlay {
        return instance
    }
    private var view: UIView?
    
    public func show() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if view == nil, let windowFrame = delegate.window?.frame {
            view = UIView(frame: windowFrame)
            delegate.window?.addSubview(view!)
            
            let darkBackground = UIView(frame: windowFrame)
            darkBackground.backgroundColor = UIColor.black
            darkBackground.alpha = 0.25
            view!.addSubview(darkBackground)
            
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            view?.addSubview(activity)
            activity.center = view!.center
            activity.startAnimating()
        }
    }
    
    public func remove() {
        for subview: UIView in view?.subviews ?? [] {
            subview.removeFromSuperview()
        }
        view?.removeFromSuperview()
    }
}

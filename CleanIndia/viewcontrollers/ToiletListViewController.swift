//
/*
ToiletListViewController.swift
Created on: 7/12/18

Abstract:
 this will show all the saved toilets in the form of table

*/

import UIKit
import Firebase

final class ToiletListViewController: UIViewController {
    
    // MARK: Properties
    
    /// PRIVATE
    @IBOutlet weak private var tableView: UITableView!
    
    private var db: Firestore!
    
    /// File Constants are declared inside this struct
    private struct C {
        static let cell = "toiletCell"
    }
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Button Actions
    
    @IBAction func onMap(_ sender: UIButton) {
        UIView.beginAnimations("View Flip", context: nil)
        UIView.setAnimationDuration(1.0)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationTransition(.flipFromRight, for: (navigationController?.view)!, cache: false)
        navigationController?.popViewController(animated: false)
        UIView.commitAnimations()
    }
}

// MARK: ToiletListViewController -> UITableViewDataSource

extension ToiletListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Store.shared.toilets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: C.cell) as? CIToiletTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: C.cell) as? CIToiletTableViewCell
        }
        
        let toilet = Store.shared.toilets[indexPath.row]
        cell?.titleLabel.text = toilet.name
        cell?.subtitleLabel.text = toilet.address
        let ratingUnAvailable = toilet.rating == nil
        cell?.cleanIndicator.isHidden = ratingUnAvailable
        cell?.cleanLabel.isHidden = ratingUnAvailable
        if !ratingUnAvailable {
            cell?.cleanIndicator.isOn = (toilet.rating ?? 0) >= 3
        }
        
        return cell!
    }
}

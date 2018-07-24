//
/*
CIToiletTableViewCell.swift
Created on: 7/12/18

Abstract:
Custom cell for the toilet details in toilet-list tableview

*/

import UIKit

final class CIToiletTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var cleanIndicator: UISwitch!
    @IBOutlet weak var cleanLabel: UILabel!
}

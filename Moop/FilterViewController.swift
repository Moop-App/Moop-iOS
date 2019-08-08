//
//  FilterViewController.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/07/11.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

protocol FilterChangeDelegate: class {
    func filterItemChanged()
}

class FilterViewController: UITableViewController {
    static func instance() -> FilterViewController {
        let vc: FilterViewController = instance(storyboardName: .main)
        return vc
    }
    
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    weak var delegate: FilterChangeDelegate?
    
    var ageTypes: [AgeType] = [] {
        didSet {
            doneButton.isEnabled = !self.theaters.isEmpty && !self.ageTypes.isEmpty
        }
    }
    var theaters: [TheaterType] = [] {
        didSet {
            doneButton.isEnabled = !self.theaters.isEmpty && !self.ageTypes.isEmpty
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.theaters = UserDefaults.standard.object([TheaterType].self, forKey: .theater) ?? TheaterType.allCases
        self.ageTypes = UserDefaults.standard.object([AgeType].self, forKey: .age) ?? AgeType.allCases
        self.tableView.reloadData()
    }
    
    @IBAction private func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func done(_ sender: UIButton) {
        UserDefaults.standard.setObject(theaters, forKey: .theater)
        UserDefaults.standard.setObject(ageTypes, forKey: .age)
        delegate?.filterItemChanged()
        self.dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let type = TheaterType(rawValue: indexPath.item) else { return UITableViewCell() }
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = type.title
                cell.accessoryType = theaters.contains(type) ? .checkmark : .none
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = type.title
                cell.accessoryType = theaters.contains(type) ? .checkmark : .none
                return cell
            }
        } else {
            guard let type = AgeType(rawValue: indexPath.item) else { return UITableViewCell() }
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = type.text
                cell.accessoryType = ageTypes.contains(type) ? .checkmark : .none
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = type.text
                cell.accessoryType = ageTypes.contains(type) ? .checkmark : .none
                return cell
            }
        }
    }
}

extension FilterViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if let type = TheaterType(rawValue: indexPath.item),
            indexPath.section == 0 {
        
            if let index = theaters.firstIndex(of: type) {
                theaters.remove(at: index)
                cell.accessoryType = .none
            } else {
                theaters.append(type)
                cell.accessoryType = .checkmark
            }
        }
        if let type = AgeType(rawValue: indexPath.item),
            indexPath.section == 1 {
            if let index = ageTypes.firstIndex(of: type) {
                           ageTypes.remove(at: index)
                           cell.accessoryType = .none
           } else {
               ageTypes.append(type)
               cell.accessoryType = .checkmark
           }
        }
    }
}

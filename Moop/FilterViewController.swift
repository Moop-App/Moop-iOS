//
//  FilterViewController.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/07/11.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

protocol FilterChangeDelegate: class {
    func theaterChanged()
}

class FilterViewController: UITableViewController {
    
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    weak var delegate: FilterChangeDelegate?
    var theaters: [TheaterType] = [] {
        didSet {
            doneButton.isEnabled = !self.theaters.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let theaters: [TheaterType] = UserDefaults.standard.object([TheaterType].self, forKey: .theater) {
            self.theaters = theaters
        } else {
            self.theaters = TheaterType.allCases
        }
        self.tableView.reloadData()
    }
    
    @IBAction private func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func done(_ sender: UIButton) {
        UserDefaults.standard.setObject(theaters, forKey: .theater)
        delegate?.theaterChanged()
        self.dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
}

extension FilterViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath),
            let type = TheaterType(rawValue: indexPath.item) else { return }
        
        if let index = theaters.firstIndex(of: type) {
            theaters.remove(at: index)
            cell.accessoryType = .none
        } else {
            theaters.append(type)
            cell.accessoryType = .checkmark
        }
    }
}

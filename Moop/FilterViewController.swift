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
            doneButton.isEnabled = !theaters.isEmpty && !ageTypes.isEmpty
            if #available(iOS 13, *) {
                let isEqualTheaters = originTheaters.sorted(by: { $0.rawValue > $1.rawValue }) == theaters.sorted(by: { $0.rawValue > $1.rawValue })
                let isEqualAges = originAgeTypes.sorted(by: { $0.rawValue > $1.rawValue }) == ageTypes.sorted(by: { $0.rawValue > $1.rawValue })
                isModalInPresentation = !(isEqualTheaters && isEqualAges)
            }
        }
    }
    var theaters: [TheaterType] = [] {
        didSet {
            doneButton.isEnabled = !theaters.isEmpty && !ageTypes.isEmpty
            if #available(iOS 13, *) {
                print("THIS IS CALLED", originTheaters.sorted(by: { $0.rawValue > $1.rawValue }) == theaters.sorted(by: { $0.rawValue > $1.rawValue }))
            }
            if #available(iOS 13, *) {
                let isEqualTheaters = originTheaters.sorted(by: { $0.rawValue > $1.rawValue }) == theaters.sorted(by: { $0.rawValue > $1.rawValue })
                let isEqualAges = originAgeTypes.sorted(by: { $0.rawValue > $1.rawValue }) == ageTypes.sorted(by: { $0.rawValue > $1.rawValue })
                isModalInPresentation = !(isEqualTheaters && isEqualAges)
            }
        }
    }
    
    let originTheaters = UserDefaults.standard.object([TheaterType].self, forKey: .theater) ?? TheaterType.allCases
    let originAgeTypes = UserDefaults.standard.object([AgeType].self, forKey: .age) ?? AgeType.allCases
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.presentationController?.delegate = self
        theaters = originTheaters
        ageTypes = originAgeTypes
        tableView.reloadData()
    }
    
    @IBAction private func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func done(_ sender: UIButton) {
        UserDefaults.standard.setObject(theaters, forKey: .theater)
        UserDefaults.standard.setObject(ageTypes, forKey: .age)
        delegate?.filterItemChanged()
        dismiss(animated: true, completion: nil)
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

@available(iOS 13.0, *)
extension FilterViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        showDismissAlert()
    }
    
    private func showDismissAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "취소".localized, style: .cancel, handler: nil))
        
        if doneButton.isEnabled {
            alert.addAction(UIAlertAction(title: "완료".localized, style: .default) { _ in
                self.done(UIButton())
            })
        }
        alert.addAction(UIAlertAction(title: "변경사항 취소하기".localized, style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        })

        present(alert, animated: true, completion: nil)
    }
}

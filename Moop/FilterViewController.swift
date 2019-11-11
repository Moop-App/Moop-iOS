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
            doneButton.isEnabled = !theaters.isEmpty && !ageTypes.isEmpty && !nations.isEmpty
            checkModalINPresentation()
        }
    }
    var theaters: [TheaterType] = [] {
        didSet {
            doneButton.isEnabled = !theaters.isEmpty && !ageTypes.isEmpty && !nations.isEmpty
            checkModalINPresentation()
        }
    }
    
    var boxOffice: Bool = false {
        didSet {
            checkModalINPresentation()
        }
    }
    
    var nations: [NationInfo] = [] {
        didSet {
            doneButton.isEnabled = !theaters.isEmpty && !ageTypes.isEmpty && !nations.isEmpty
            checkModalINPresentation()
        }
    }
    
    let originTheaters = FilterData.theater
    let originAgeTypes = FilterData.age
    let originBoxOffice = FilterData.boxOffice
    let originNations = FilterData.nation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.presentationController?.delegate = self
        theaters = originTheaters
        ageTypes = originAgeTypes
        boxOffice = originBoxOffice
        nations = originNations
        tableView.reloadData()
    }
    
    @IBAction private func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func done(_ sender: UIButton) {
        FilterData.theater = theaters
        FilterData.age = ageTypes
        FilterData.boxOffice = boxOffice
        FilterData.nation = nations
        delegate?.filterItemChanged()
        dismiss(animated: true, completion: nil)
    }
    
    private func checkModalINPresentation() {
        if #available(iOS 13, *) {
            let isEqualTheaters = originTheaters.sorted(by: { $0.rawValue > $1.rawValue }) == theaters.sorted(by: { $0.rawValue > $1.rawValue })
            let isEqualAges = originAgeTypes.sorted(by: { $0.rawValue > $1.rawValue }) == ageTypes.sorted(by: { $0.rawValue > $1.rawValue })
            let isEqualBoxOfffice = originBoxOffice == boxOffice
            isModalInPresentation = !(isEqualTheaters && isEqualAges && isEqualBoxOfffice)
        }
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
        } else if indexPath.section == 1 {
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
        } else if indexPath.section == 2 {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = "박스오피스 순으로 정렬하기".localized
                cell.accessoryType = boxOffice ? .checkmark : .none
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = "박스오피스 순으로 정렬하기".localized
                cell.accessoryType = boxOffice ? .checkmark : .none
                return cell
            }
        } else {
            let type = NationInfo(isKorean: indexPath.item == 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = type.rawValue.localized
                cell.accessoryType = nations.contains(type) ? .checkmark : .none
                return cell
            } else {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = type.rawValue.localized
                cell.accessoryType = nations.contains(type) ? .checkmark : .none
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
        if indexPath.section == 2 {
            boxOffice.toggle()
            cell.accessoryType = boxOffice ? .checkmark : .none
        }
        if indexPath.section == 3 {
            let type = NationInfo(isKorean: indexPath.item == 0)
            if let index = nations.firstIndex(of: type) {
                            nations.remove(at: index)
                            cell.accessoryType = .none
            } else {
                nations.append(type)
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

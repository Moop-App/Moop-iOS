//
//  FilterView.swift
//  Moop
//
//  Created by Chang Woo Son on 2019/07/11.
//  Copyright © 2019 kor45cw. All rights reserved.
//

import UIKit

protocol FilterChangeDelegate: class {
    func filterItemChanged()
}

class FilterView: UITableViewController {
    static func instance() -> FilterView {
        let vc: FilterView = instance(storyboardName: Storyboard.filter)
        vc.presenter = FilterPresenter(view: vc)
        return vc
    }
    
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    var presenter: FilterPresenterDelegate!
    weak var delegate: FilterChangeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        navigationController?.presentationController?.delegate = self
    }
    
    @IBAction private func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func done(_ sender: UIButton) {
        presenter.done()
        delegate?.filterItemChanged()
        dismiss(animated: true, completion: nil)
    }
}

extension FilterView: FilterViewDelegate {
    func loadFinished() {
        self.tableView.reloadData()
    }
    
    func updateDataInfo() {
        doneButton.isEnabled = presenter.isDoneButtonEnable
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = presenter.isModalInPresentation
        }
    }
}

extension FilterView {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let (title, isSelected) = presenter[indexPath] else { return UITableViewCell() }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.textLabel?.text = title
            cell.accessoryType = isSelected ? .checkmark : .none
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = title
            cell.accessoryType = isSelected ? .checkmark : .none
            return cell
        }
    }
}

extension FilterView {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath),
            let isSelected = presenter.didSelect(with: indexPath) else { return }
        
        cell.accessoryType = isSelected ? .checkmark : .none
    }
}

@available(iOS 13.0, *)
extension FilterView: UIAdaptivePresentationControllerDelegate {
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

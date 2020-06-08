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

class FilterView: UIViewController {
    static func instance() -> FilterView {
        let vc: FilterView = instance(storyboardName: Storyboard.filter)
        vc.presenter = FilterPresenter(view: vc)
        return vc
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var 광고포장뷰: UIView!
    @IBOutlet private weak var bannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    var presenter: FilterPresenterDelegate!
    weak var delegate: FilterChangeDelegate?
    
    private lazy var 광고모듈: AdManager = AdManager(배너광고타입: .필터, viewController: self, wrapperView: 광고포장뷰)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        navigationController?.presentationController?.delegate = self
        configureAd()
    }
    
    private func configureAd() {
        guard !UserData.isAdFree else {
            광고포장뷰.removeFromSuperview()
            return
        }
        광고모듈.delegate = self
        광고모듈.배너보여줘()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerAd()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }
    
    func loadBannerAd() {
        guard !UserData.isAdFree else { return }
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).size.width
        bannerViewHeightConstraint.constant = 광고모듈.resize배너(width: viewWidth)
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
        isModalInPresentation = presenter.isModalInPresentation
    }
}

extension FilterView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let (section, item, isSelected) = presenter[indexPath] else { return UITableViewCell() }
        
        switch (section, item) {
        case (_, .header):
            let cell: SettingHeaderCell = tableView.dequeueReusableCell(for: indexPath)
            cell.set(section.title)
            return cell
        default:
            let cell: FilterCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(item, isSelected: isSelected)
            return cell
        }
    }
}

extension FilterView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterCell,
            let isSelected = presenter.didSelect(with: indexPath) else { return }
        
        cell.checkButton.isHidden = !isSelected
    }
}

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

extension FilterView: AdManagerDelegate {
    func 배너광고Loaded() {
        loadBannerAd()
    }
}

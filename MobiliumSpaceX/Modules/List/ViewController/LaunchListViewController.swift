//
//  LaunchListViewController.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 4.02.2023.
//

import UIKit
import SDWebImage 

class LaunchListViewController: UIViewController {

    @IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var segmentControl: UISegmentedControl!
    @IBOutlet weak private var tableViewLaunches: UITableView!
    
    private let factory: ViewControllerFactory
    private let viewModel: LaunchListViewModel
    private let refreshControl = UIRefreshControl()
    
    init(factory: ViewControllerFactory, viewModel: LaunchListViewModel) {
        self.factory = factory
        self.viewModel = viewModel
        super.init(nibName: Self.className, bundle: Self.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        requestContent()
    }
  
    private func prepareUI() {
        viewModel.delegate = self
        setUpSegmentedControl()
        prepareTableView()
    }
    
    //MARK: Actions
 
    
    @IBAction func actSegmentControl(_ sender: UISegmentedControl) {
        tableViewLaunches.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        loadingIndicator.startAnimating()
        requestContent()
        tableViewLaunches.reloadData()
    }
    
    //MARK: Segment Control
    private func setUpSegmentedControl() {
        segmentControl.selectedSegmentIndex = 0
    }
}

// MARK: - Auxiliary Methods
private extension LaunchListViewController {
    
    func prepareTableView() {
        tableViewLaunches.delegate = self
        tableViewLaunches.dataSource = self
        tableViewLaunches.separatorStyle = .none
        tableViewLaunches.register(LaunchTableViewCell.nib, forCellReuseIdentifier: LaunchTableViewCell.className)
        tableViewLaunches.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh() {
        requestContent()
        refreshControl.endRefreshing()
        tableViewLaunches.reloadData()
    }
    
    func requestContent() {
        if segmentControl.selectedSegmentIndex == 0 {
            viewModel.getUpcomingLaunches()
        } else {
            viewModel.getPastLaunches()
        }
        loadingIndicator.startAnimating()
    }
}

extension LaunchListViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            return viewModel.upcomingLaunches.count
        }
        
        return viewModel.pastLaunches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LaunchTableViewCell = tableViewLaunches.dequeueReusableCell(withIdentifier: LaunchTableViewCell.className) as! LaunchTableViewCell
        cell.selectionStyle = .none
        
        if segmentControl.selectedSegmentIndex == 0 {
            let item = viewModel.upcomingLaunches[indexPath.row]
            cell.lblTitle.text = item.name ?? ""
            
            if let date = Date.date(from: item.date_utc) {
                cell.lblSubTitle.text = date.customDateWithHour
            }
            
            if let links = item.links,
               let itemPatch = links.patch,
               let imgUrl = itemPatch.small, !imgUrl.isEmpty {
                cell.imgView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "img_product"))
            } else {
                cell.imgView.image = UIImage(named: "img_product")
            }
        } else {
            let item = viewModel.pastLaunches[indexPath.row]
            cell.lblTitle.text = item.name ?? ""
            
            if let date = Date.date(from: item.dateUtc) {
                cell.lblSubTitle.text = date.customDateWithHour
            }
            
            if let links = item.links,
               let itemPatch = links.patch,
               let imgUrl = itemPatch.small, !imgUrl.isEmpty {
                cell.imgView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "img_product"))
            } else {
                cell.imgView.image = UIImage(named: "img_product")
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.upcomingLaunches.count - 1 {
            viewModel.getQuery(isUpcoming: (segmentControl.selectedSegmentIndex == 0))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedLaunchId: String = ""
        if segmentControl.selectedSegmentIndex == 0 {
            selectedLaunchId = viewModel.upcomingLaunches[indexPath.row].id ?? ""
        }else {
            selectedLaunchId = viewModel.pastLaunches[indexPath.row].id ?? ""
        }
        
        navigationController?.pushViewController(factory.makeDetail(launchId: selectedLaunchId,
                                                                    isUpcoming: (segmentControl.selectedSegmentIndex == 0)), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

// MARK: - LaunchListViewModelDelegate

extension LaunchListViewController: LaunchListViewModelDelegate {
    func upcomingLaunchesDidSet() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableViewLaunches.isHidden = false
            self.tableViewLaunches.reloadData()
        }
    }
    
    func pastLaunchesDidSet() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.tableViewLaunches.isHidden = false
            self.tableViewLaunches.reloadData()
        }
    }
    
    func errorOccured(_ error: Error?) {
        tableViewLaunches.isHidden = true
        loadingIndicator.stopAnimating()
        view.makeToast("Something went wrong, try again later.", duration: 3.0, position: .center)
    }
}

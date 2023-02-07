//
//  LaunchDetailViewController.swift
//  MobiliumSpaceX
//
//  Created by Deniz Nargiz on 4.02.2023.
//

import UIKit
import Toast_Swift

class LaunchDetailViewController: UIViewController {
    
    @IBOutlet weak private var stackviewContent: UIStackView!
    @IBOutlet weak private var lblScreenTitle: UILabel!
    @IBOutlet weak private var lblLaunchName: UILabel!
    
    @IBOutlet weak private var imgViewLaunch: UIImageView!
    @IBOutlet weak private var viewPastLaunchDate: UIView!
    @IBOutlet weak private var lblPastLaunchDate: UILabel!
    
    @IBOutlet weak private var viewUpcomingLaunchDate: UIView!
    @IBOutlet weak private var lblUpcomingLaunchDate: UILabel!
    
    //Properties About Launch
    @IBOutlet weak private var lblLandingAttempt: UILabel!
    @IBOutlet weak private var lblLandingType: UILabel!
    @IBOutlet weak private var lblUpcoming: UILabel!
    @IBOutlet weak private var lblLandingSuccess: UILabel!
    @IBOutlet weak private var lblFlightNumber: UILabel!
    @IBOutlet weak private var lblDatePrecision: UILabel!
    
    @IBOutlet weak private var viewYoutube: RoundedUIView!
    @IBOutlet weak private var viewPressKit: RoundedUIView!
    
    @IBOutlet weak var lblCounterForUpcoming: UILabel!
    @IBOutlet weak private var loadingIndicator: UIActivityIndicatorView!
        
    private let factory: ViewControllerFactory
    private let viewModel: LaunchDetailViewModel
    private let launchId: String
    private let isUpcoming: Bool
    
    init(factory: ViewControllerFactory,
         viewModel: LaunchDetailViewModel,
         launchId: String,
         isUpcoming: Bool) {
        self.factory = factory
        self.viewModel = viewModel
        self.launchId = launchId
        self.isUpcoming = isUpcoming
        super.init(nibName: Self.className, bundle: Self.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        viewModel.delegate = self
        loadingIndicator.startAnimating()
        
        if isUpcoming {
            viewModel.getLaunchDetail(launchId: launchId)
        }else {
            viewModel.getPastLaunchDetail(launchId: launchId)
        }
        
    }
    
    private func prepareUI() {
        stackviewContent.isHidden = false
        loadingIndicator.stopAnimating()
        
        if isUpcoming {
            lblScreenTitle.text =  "Launches Upcoming"
            viewPastLaunchDate.isHidden = true
            viewUpcomingLaunchDate.isHidden = false
            
            lblLaunchName.text = viewModel.launchDetail.name ?? ""
            
            if let links = viewModel.launchDetail.links,
               let itemPatch = links.patch,
               let imgUrl = itemPatch.small, !imgUrl.isEmpty {
                imgViewLaunch.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "img_product"))
            } else {
                imgViewLaunch.image = UIImage(named: "img_product")
            }
            
            lblUpcomingLaunchDate.text = Date.date(from: viewModel.launchDetail.date_utc)?.customDate
            
            if let cores = viewModel.launchDetail.cores{
                let core = cores[0]
                lblLandingAttempt.text = (core.landing_attempt != nil) ? String(core.landing_attempt!) : "-"
                lblLandingType.text = (core.landing_type != nil) ? String(core.landing_type!) : "-"
                lblLandingSuccess.text = (core.landing_success != nil) ? String(core.landing_success!) : "-"
            } else {
                lblLandingAttempt.text =  "-"
                lblLandingType.text = "-"
                lblLandingSuccess.text = "-"
            }
            
            if let flightNumb = viewModel.launchDetail.flight_number {
                lblFlightNumber.text = String(flightNumb)
            } else {
                lblFlightNumber.text = "-"
            }
            
            lblUpcoming.text = String(viewModel.launchDetail.upcoming ?? false)
            lblDatePrecision.text = viewModel.launchDetail.date_precision ?? "-"
            
            if let links = viewModel.launchDetail.links {
                
                if let youtubeLink = links.webcast {
                    viewYoutube.isHidden = false
                    let tap = UITapGestureRecognizer(target: self, action: #selector(handleLinksTap(_:)))
                    tap.accessibilityLabel = youtubeLink
                    viewYoutube.addGestureRecognizer(tap)
                } else {
                    viewYoutube.isHidden = true
                }
                
                if let presskitLink = links.presskit {
                    let tap = UITapGestureRecognizer(target: self, action: #selector(handleLinksTap(_:)))
                    tap.accessibilityLabel = presskitLink
                    viewPressKit.addGestureRecognizer(tap)
                    viewPressKit.isHidden = false
                } else {
                    viewPressKit.isHidden = true
                }
                
            }else {
                viewYoutube.isHidden = true
                viewPressKit.isHidden = true
            }
            
            
        } else {
            lblScreenTitle.text =  "Launches Past"
            viewPastLaunchDate.isHidden = false
            viewUpcomingLaunchDate.isHidden = true
            
            lblLaunchName.text = viewModel.pastLaunchDetail.name ?? ""
            
            if let links = viewModel.pastLaunchDetail.links,
               let itemPatch = links.patch,
               let imgUrl = itemPatch.small, !imgUrl.isEmpty {
                imgViewLaunch.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "img_product"))
            } else {
                imgViewLaunch.image = UIImage(named: "img_product")
            }
            
            lblPastLaunchDate.text = Date.date(from: viewModel.pastLaunchDetail.date_utc)?.customDate
            
            if let cores = viewModel.pastLaunchDetail.cores{
                let core = cores[0]
                lblLandingAttempt.text = (core.landing_attempt != nil) ? String(core.landing_attempt!) : "-"
                lblLandingType.text = (core.landing_type != nil) ? String(core.landing_type!) : "-"
                lblLandingSuccess.text = (core.landing_success != nil) ? String(core.landing_success!) : "-"
            } else {
                lblLandingAttempt.text =  "-"
                lblLandingType.text = "-"
                lblLandingSuccess.text = "-"
            }
            
            if let flightNumb = viewModel.pastLaunchDetail.flight_number {
                lblFlightNumber.text = String(flightNumb)
            }else {
                lblFlightNumber.text = "-"
            }
            
            lblUpcoming.text = String(viewModel.pastLaunchDetail.upcoming ?? false)
            lblDatePrecision.text = viewModel.pastLaunchDetail.date_precision ?? "-"
            
            if let links = viewModel.pastLaunchDetail.links {
                
                if let youtubeLink = links.webcast {
                    viewYoutube.isHidden = false
                    let tap = UITapGestureRecognizer(target: self, action: #selector(handleLinksTap(_:)))
                    tap.accessibilityLabel = youtubeLink
                    viewYoutube.addGestureRecognizer(tap)
                } else {
                    viewYoutube.isHidden = true
                }
                
                if let presskitLink = links.presskit {
                    let tap = UITapGestureRecognizer(target: self, action: #selector(handleLinksTap(_:)))
                    tap.accessibilityLabel = presskitLink
                    viewPressKit.addGestureRecognizer(tap)
                    viewPressKit.isHidden = false
                } else {
                    viewPressKit.isHidden = true
                }
                
            }else {
                viewYoutube.isHidden = true
                viewPressKit.isHidden = true
            }
        }
        
    }
    
    @objc private func handleLinksTap(_ sender: UITapGestureRecognizer? = nil) {
        if let str = sender?.accessibilityLabel, let url = URL(string: str) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - LaunchDetailViewModelDelegate

extension LaunchDetailViewController: LaunchDetailViewModelDelegate {
    func pastLaunchDetailDidSet() {
        prepareUI()
    }
    
    func launchDetailDidSet() {
        prepareUI()
    }
    
    func errorOccured(_ error: Error?) {
        stackviewContent.isHidden = true
        loadingIndicator.stopAnimating()
        view.makeToast("Something went wrong, try again later.", duration: 3.0, position: .center)
    }
}

extension LaunchDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(navigationController?.interactivePopGestureRecognizer) {
            navigationController?.popViewController(animated: true)
        }
        return false
    }
}

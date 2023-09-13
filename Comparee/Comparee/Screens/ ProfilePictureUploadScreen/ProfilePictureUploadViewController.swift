//
//  ProfilePictureUploadViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/4/23.
//

import CropViewController
import Combine
import UIKit

final class ProfilePictureUploadViewController: UIViewController {
    // MARK: - Private properties for UI configuration
    private lazy var backgroundImageView = BackgroundImageView()
    private lazy var addPhotoButton = PhotoAddButton()
    private lazy var adviceImageView = AdviceImageView()
    private lazy var regButton = RoundedWhiteView()
    private lazy var selectedImage = PreviewView()
    
    // MARK: - Private properties
    private var viewModel: ProfilePictureUploadViewModelProtocol!
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: ProfilePictureUploadViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
}

private extension ProfilePictureUploadViewController {
    func configureViews() {
        bindButton()
        setupViews()
        setConstraints()
    }
    
    func showImage(image: UIImage) {
        selectedImage.setImage(image: image)
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        selectedImage.layer.cornerRadius = 16
        selectedImage.clipsToBounds = true
        selectedImage.heightAnchor.constraint(equalTo: selectedImage.widthAnchor, multiplier: 4.0/3.0).isActive = true
        NSLayoutConstraint.activate([
            selectedImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectedImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

// MARK: - Binding
private extension ProfilePictureUploadViewController {
    func bindButton() {
        addPhotoButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                
                viewModel.input.plusButtonPressed(viewController: self)
            }
            .store(in: &cancellables)
        
        regButton.authButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                
                viewModel.input.continueButtonPressed()
            }
            .store(in: &cancellables)
        
        selectedImage.cancellButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                
                selectedImage.isHidden = true
                viewModel.input.dismissImage()
            }
            .store(in: &cancellables)
    }
    
}

extension ProfilePictureUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true)
        
        startCrop(image: image)
        //viewModel.input.startCrop(image: image, viewController: self)
    }
    
    //   Only for test , should be deleted
    func startCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.delegate = self
        vc.aspectRatioPreset = .preset4x3
        vc.aspectRatioLockEnabled = true
        vc.aspectRatioPickerButtonHidden = false
        vc.toolbarPosition = .bottom
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Back"
        present(vc, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        viewModel.input.image = image
        showImage(image: image)
        selectedImage.isHidden = false
    }
}

// MARK: - Setting configurations for UI
private extension ProfilePictureUploadViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(addPhotoButton)
        view.addSubview(adviceImageView)
        view.addSubview(regButton)
        view.addSubview(selectedImage)
        
        let customTitleView = createCustomTitleView(contactName: "Sign Up")
        navigationItem.titleView = customTitleView
        createCustomNavigationBar()
    }
    
    func setConstraints() {
        if isDeviceWithSafeArea() {
            regButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66).isActive = true
        } else {
            regButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -19),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 60),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 60),
            
            adviceImageView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 19),
            adviceImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adviceImageView.widthAnchor.constraint(equalToConstant: 150),
            adviceImageView.heightAnchor.constraint(equalToConstant: 60),
            
            regButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            regButton.widthAnchor.constraint(equalToConstant: 76),
            regButton.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
}

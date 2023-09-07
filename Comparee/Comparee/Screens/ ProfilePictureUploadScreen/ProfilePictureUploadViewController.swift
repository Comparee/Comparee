//
//  ProfilePictureUploadViewController.swift
//  Comparee
//
//  Created by Андрей Логвинов on 9/4/23.
//

import Combine
import UIKit
import CropViewController
import FirebaseAuth

final class ProfilePictureUploadViewController: UIViewController {
    // MARK: - Private properties for UI configuration
    private lazy var backgroundImageView: UIImageView = BackgroundImageView()
    private lazy var addPhotoButton: UIButton = PhotoAddButton()
    private lazy var adviceImageView: UIImageView = AdviceImageView()
    private lazy var regButton = RoundedWhiteView()
    
    var storage = StorageManager()
    
    // MARK: - Property for Combine
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        bindButton()
        setupViews()
        setConstraints()
    }
}

// MARK: - Binding
private extension ProfilePictureUploadViewController {
    func bindButton() {
        addPhotoButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                self.didTapButton()
                print("Button tapped")
                
            }
            .store(in: &cancellables)
    }
}

extension ProfilePictureUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func didTapButton() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true)
        showCrop(image: image)
    }
}

extension ProfilePictureUploadViewController: CropViewControllerDelegate {
    func showCrop(image: UIImage) {
        let vc = CropViewController(croppingStyle: .default, image: image)
        vc.aspectRatioPreset = .presetSquare
        vc.aspectRatioLockEnabled = false
        vc.toolbarPosition = .bottom
        vc.delegate = self
        vc.doneButtonTitle = "Continue"
        vc.cancelButtonTitle = "Quit"
        present(vc, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true)
        storage.saveImage(with: image.pngData()!, fileName: "First")
    }
}

// MARK: - Setting configurations for UI
private extension ProfilePictureUploadViewController {
    func setupViews() {
        view.addSubview(backgroundImageView)
        view.addSubview(addPhotoButton)
        view.addSubview(adviceImageView)
        view.addSubview(regButton)
        
        let customTitleView = createCustomTitleView(contactName: "Sign Up")
        navigationItem.titleView = customTitleView
        createCustomNavigationBar()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -19),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 60),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 60),
            
            adviceImageView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 19 ),
            adviceImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adviceImageView.widthAnchor.constraint(equalToConstant: 150),
            adviceImageView.heightAnchor.constraint(equalToConstant: 60),
            
            regButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66),
            regButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            regButton.widthAnchor.constraint(equalToConstant: 76),
            regButton.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
}

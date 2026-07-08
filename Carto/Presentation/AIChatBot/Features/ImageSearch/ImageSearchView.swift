//
//  ImageSearchView.swift
//  Carto
//
//  Created by Osama Hosam on 08/07/2026.
//
import SwiftUI
import PhotosUI

struct ImageSearchView: View {
    @StateObject private var viewModel: ImageSearchViewModel
    @EnvironmentObject private var router: Router<AppRoute>
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var showCamera = false

    init(
        findSimilarProductUseCase: FindSimilarProductFromImageUseCase,
        productUseCase: ProductUseCaseProtocol
    ) {
        _viewModel = StateObject(wrappedValue: ImageSearchViewModel(
            findSimilarProductUseCase: findSimilarProductUseCase,
            productUseCase: productUseCase
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(title: "Search by Photo")

            ScrollView {
                VStack(spacing: 24) {
                    imagePreviewSection
                    resultSection
                }
                .padding(.top, 24)
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
        }
        .background(AmbientBlobBackground())
        .safeAreaInset(edge: .bottom) {
            bottomActionBar
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker { image in
                viewModel.setImage(image)
            }
        }
        .onChange(of: photoPickerItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.setImage(image)
                }
            }
        }
    }

    // MARK: - Image Preview

    @ViewBuilder
    private var imagePreviewSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6).opacity(0.6))
                .frame(height: 340)

            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 340)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                if case .loading = viewModel.state {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                    VStack(spacing: 10) {
                        ProgressView()
                            .controlSize(.large)
                        Text("Finding the closest match…")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                // Clear/reset the photo without needing to scroll down
                if case .loading = viewModel.state {
                    // hide reset while searching
                } else {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation { viewModel.reset() }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.white, .black.opacity(0.5))
                            }
                            .padding(10)
                        }
                        Spacer()
                    }
                }
            } else {
                VStack(spacing: 14) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 44, weight: .light))
                        .foregroundColor(.secondary)
                    VStack(spacing: 4) {
                        Text("Search by photo")
                            .font(.headline)
                        Text("Take or upload a picture and we'll find the closest match in our catalog")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedImage)
    }
    // MARK: - Result

    @ViewBuilder
    private var resultSection: some View {
        switch viewModel.state {
        case .idle, .loading:
            EmptyView()

        case .success(let product):
            VStack(spacing: 14) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .foregroundColor(.blue)
                    Text("We found your match")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                }

                Button {
                    router.push(to: .productDetails(product: product))
                } label: {
                    HStack(spacing: 14) {
                        OutfitGridItemCard(product: product) {
                            router.push(to: .productDetails(product: product))
                        }
                        .frame(width: 110)
                        .allowsHitTesting(false) // avoid nested tap conflicts; outer button handles navigation

                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .lineLimit(2)

                            Text("by \(product.vendor)")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text(product.displayPrice)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .padding(.top, 2)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(12)
                    .background(Color(.systemGray6).opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))

        case .failure(let error):
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.magnifyingglass")
                    .font(.system(size: 30))
                    .foregroundColor(.secondary)

                Text("No match found")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(error.localizedDescription)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(.systemGray6).opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .transition(.opacity)
        }
    }
    
    // MARK: - Bottom Bar

    private var bottomActionBar: some View {
        HStack(spacing: 14) {
            iconActionButton(
                systemImage: "photo.on.rectangle",
                label: "Library"
            ) {
                photoPickerItem = nil // reset so onChange fires even for same photo re-pick
            }
            .overlay(
                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    Color.clear
                }
            )

            iconActionButton(
                systemImage: "camera.fill",
                label: "Camera"
            ) {
                showCamera = true
            }

            Button {
                Task { await viewModel.searchForMatch() }
            } label: {
                HStack(spacing: 8) {
                    if case .loading = viewModel.state {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "sparkle.magnifyingglass")
                    }
                    Text("Search")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(viewModel.selectedImage == nil ? Color.blue.opacity(0.4) : Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(viewModel.selectedImage == nil || isSearching)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(.ultraThinMaterial)
    }

    private var isSearching: Bool {
        if case .loading = viewModel.state { return true }
        return false
    }

    private func iconActionButton(
        systemImage: String,
        label: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .medium))
                Text(label)
                    .font(.caption2)
            }
            .frame(width: 64, height: 52)
            .background(Color(.systemGray6))
            .foregroundColor(.primary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

// MARK: - Camera capture wrapper
struct CameraPicker: UIViewControllerRepresentable {
    let onImagePicked: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

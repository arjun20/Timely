//
//  PerformanceManager.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import Foundation
import SwiftUI

class PerformanceManager: ObservableObject {
    static let shared = PerformanceManager()
    
    private init() {}
    
    // MARK: - Performance Monitoring
    private var startTime: CFAbsoluteTime = 0
    
    func startTiming() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func endTiming(operation: String) {
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("⏱️ \(operation) took \(timeElapsed) seconds")
        
        // Log slow operations
        if timeElapsed > 1.0 {
            print("⚠️ Slow operation detected: \(operation)")
        }
    }
    
    // MARK: - Memory Management
    func logMemoryUsage() {
        var memoryInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &memoryInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMB = memoryInfo.resident_size / 1024 / 1024
            print("📱 Memory usage: \(usedMB) MB")
        }
    }
    
    // MARK: - Image Caching
    private let imageCache = NSCache<NSString, UIImage>()
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func cachedImage(forKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
    
    // MARK: - Data Caching
    private let dataCache = NSCache<NSString, NSData>()
    
    func cacheData(_ data: Data, forKey key: String) {
        dataCache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func cachedData(forKey key: String) -> Data? {
        return dataCache.object(forKey: key as NSString) as Data?
    }
}

// MARK: - Performance Optimized Views
struct LazyLoadingView<Content: View>: View {
    let content: () -> Content
    @State private var isLoaded = false
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        if isLoaded {
            content()
        } else {
            ProgressView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isLoaded = true
                    }
                }
        }
    }
}

// MARK: - Debounced Text Field
struct DebouncedTextField: View {
    let title: String
    @Binding var text: String
    let onTextChanged: (String) -> Void
    
    @State private var debounceTask: Task<Void, Never>?
    
    var body: some View {
        TextField(title, text: $text)
            .onChange(of: text) { _, newValue in
                debounceTask?.cancel()
                debounceTask = Task {
                    try? await Task.sleep(nanoseconds: 300_000_000) // 300ms
                    if !Task.isCancelled {
                        onTextChanged(newValue)
                    }
                }
            }
    }
}

// MARK: - Performance Optimized List
struct OptimizedList<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let data: Data
    let content: (Data.Element) -> Content
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(data), id: \.id) { item in
                content(item)
            }
        }
    }
}

// MARK: - Memory Efficient Image Loading
struct OptimizedAsyncImage: View {
    let url: URL?
    let placeholder: Image
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if isLoading {
            placeholder
                .foregroundColor(.secondary)
        } else {
            placeholder
                .foregroundColor(.secondary)
                .onAppear {
                    loadImage()
                }
        }
    }
    
    private func loadImage() {
        guard let url = url, image == nil else { return }
        
        isLoading = true
        
        // Check cache first
        if let cachedImage = PerformanceManager.shared.cachedImage(forKey: url.absoluteString) {
            image = cachedImage
            isLoading = false
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let loadedImage = UIImage(data: data) {
                    await MainActor.run {
                        image = loadedImage
                        isLoading = false
                        PerformanceManager.shared.cacheImage(loadedImage, forKey: url.absoluteString)
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
}

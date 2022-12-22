import XCTest
@testable import ImageLoaderWithFallbackComposite
@testable import Domain

class ImageLoaderWithFallbackComposite: ImageLoader {
    private let primary: ImageLoader
    private let fallback: ImageLoader
    
    init(primary: ImageLoader, fallback: ImageLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func load(completion: @escaping (ImageLoader.Result) -> Void) {
        primary.load { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
}

final class ImageLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimaryImageOnPrimarySuccess() {
        let primaryImage = uniqueImage()
        let fallbackImage = uniqueImage()
        
        let sut = makeSUT(primaryResult: .success(primaryImage), fallbackResult: .success(fallbackImage))
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { result in
            switch result {
            case let .success(receivedImage):
                XCTAssertEqual(receivedImage, primaryImage)
                
            case .failure:
                XCTFail("Expected successful load result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_load_deliversFallbackOnPrimaryFailure() {
        let fallbackImage = uniqueImage()
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackImage))
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { result in
            switch result {
            case let .success(receivedImage):
                XCTAssertEqual(receivedImage, fallbackImage)
                
            case .failure:
                XCTFail("Expected successfull load image result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - Helpers
    
    private func uniqueImage() -> [ImageItem] {
        return [ImageItem(id: UUID(), description: "any", url: URL(string: "http://any-url.com")!)]
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private class loaderStub: ImageLoader {
        private let result: ImageLoader.Result
        
        init(result: ImageLoader.Result) {
            self.result = result
        }
        
        func load(completion: @escaping (ImageLoader.Result) -> Void) {
            completion(result)
        }
    }
    
    private func makeSUT(primaryResult: ImageLoader.Result, fallbackResult: ImageLoader.Result, file: StaticString = #file, line: UInt = #line) -> ImageLoader {
        
        let primaryLoader = loaderStub(result: primaryResult)
        let fallbackLoader = loaderStub(result: fallbackResult)
        
        let sut = ImageLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        trackForMemoryLeaks(primaryLoader, file: file, line: line)
        trackForMemoryLeaks(fallbackLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

import XCTest
@testable import ImageLoaderWithFallbackComposite
@testable import Domain

class ImageLoaderWithFallbackComposite: ImageLoader {
    private let primary: ImageLoader
    
    init(primary: ImageLoader, fallback: ImageLoader) {
        self.primary = primary
    }
    
    func load(completion: @escaping (ImageLoader.Result) -> Void) {
        primary.load(completion: completion)
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
    
    // MARK: - Helpers
    
    private func uniqueImage() -> [ImageItem] {
        return [ImageItem(id: UUID(), description: "any", url: URL(string: "http://any-url.com")!)]
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
        
        return sut
    }
}

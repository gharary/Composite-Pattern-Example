import XCTest
@testable import ImageLoaderWithFallbackComposite
@testable import Domain


final class ImageLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimaryImageOnPrimarySuccess() {
        let primaryImage = uniqueImage()
        let fallbackImage = uniqueImage()
        
        let sut = makeSUT(primaryResult: .success(primaryImage), fallbackResult: .success(fallbackImage))
        
        expect(sut, toCompleteWith: .success(primaryImage))
    }
    
    func test_load_deliversFallbackOnPrimaryFailure() {
        let fallbackImage = uniqueImage()
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackImage))
        
        expect(sut, toCompleteWith: .success(fallbackImage))
    }
    
    func test_load_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
        
        expect(sut, toCompleteWith: .failure(anyNSError()))
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
    
    private func expect(_ sut: ImageLoader, toCompleteWith expectedResult: ImageLoader.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedResult), .success(expectedResult)):
                XCTAssertEqual(receivedResult, expectedResult, file: file, line: line)
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

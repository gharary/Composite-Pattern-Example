
# Composite Pattern Simple Example

This project is a simple implementation of a Composite Pattern and how it can be helpful in our projects.

## Installation

To use the package, clone and run it!

## Explanation

Project inclused 3 Packages and a project.

`Domain`: which is the subject area on which the application is intended to apply. 

`Networking`: which is  the networking layer which is responsible to pass the data or error. In this package, I hardcoded the returned data to reach the behaviour we have in mind.

 `ImageLoaderWithFallbackComposite`: which is the implementation of  simple networking to load some images from server/backend, which is done withing composite pattern in TDD

`CompositePatternExample`: which is the app that uses those packages, and implement the image loader. The interesting part here is that I want the app to fetch for the image 2 times from the local and if it failed, then tries to fetch the image from remote url.
Therefore I have implemented it as this way:
```
let contentView = UIComposer.viewComposedWith(imageLoader: ImageLoaderWithFallbackComposite(
        primary: LocalImageLoader(),
        fallback: ImageLoaderWithFallbackComposite(
            primary: LocalImageLoader(),
            fallback: RemoteImageLoader())))
```

As you can see, for the fallback loader, I also injected the image loader with local loader as primary and remote loader as fallback.


## Contributing

Pull requests are welcome. 

## License

[MIT](https://choosealicense.com/licenses/mit/)

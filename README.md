# CIImageTester
CIFilter broken in Xcode11 with Simulator?

# Test environment
Xcode 11.2.1
macOS Mojave 10.14.6
MacBook Pro (15-inch, 2017)

# Broken preview
![Preview](https://github.com/hiralin/CIImageTester/blob/master/preview.jpg)

# 201912/17 RESOLVED!
This issue resolved by adding "autoreleasepool" block in each image processing loop.

https://github.com/hiralin/CIImageTester/blob/master/CIImageTester.playground/Contents.swift#L54

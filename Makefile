.PHONY: help build clean test archive ipa

help:
	@echo "iOS AI Executor (Ronix) - Build Commands"
	@echo "========================================="
	@echo "make build      - Build for simulator"
	@echo "make test       - Run unit tests"
	@echo "make clean      - Clean build artifacts"
	@echo "make archive    - Create app archive"
	@echo "make ipa        - Generate IPA for distribution"

clean:
	@rm -rf build/ .build/
	@echo "✓ Clean complete"

test:
	@swift test --verbose

build:
	@xcodebuild build -scheme iOS-AI-executor -configuration Debug

archive:
	@xcodebuild -scheme iOS-AI-executor -configuration Release -archivePath build/ronix.xcarchive archive

ipa: archive
	@mkdir -p build/ipa
	@xcodebuild -exportArchive -archivePath build/ronix.xcarchive -exportOptionsPlist export-options.plist -exportPath build/ipa

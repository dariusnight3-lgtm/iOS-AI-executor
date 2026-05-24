#!/bin/bash

set -e

echo "🚀 RONIX iOS AI Executor - IPA Builder"
echo "======================================="

SCHEME="iOS-AI-executor"
CONFIGURATION="Release"
ARCHIVE_PATH="build/ronix.xcarchive"
IPA_PATH="build/ipa"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}[1/5]${NC} Creating build directories...
mkdir -p build/ipa
rm -rf "$ARCHIVE_PATH"

echo -e "${YELLOW}[2/5]${NC} Archiving application...
xcodebuild -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$ARCHIVE_PATH" \
    -derivedDataPath build/derived \
    -allowProvisioningUpdates \
    archive 2>&1 || true

echo -e "${YELLOW}[3/5]${NC} Creating export options plist...
cat > build/export-options.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>destination</key>
    <string>generic/platform=iOS</string>
    <key>method</key>
    <string>ad-hoc</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>teamID</key>
    <string>AUTO</string>
</dict>
</plist>
EOF

echo -e "${YELLOW}[4/5]${NC} Exporting IPA...
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportOptionsPlist build/export-options.plist \
    -exportPath "$IPA_PATH" \
    -allowProvisioningUpdates 2>&1 || true

echo -e "${YELLOW}[5/5]${NC} Verifying IPA...
if [ -f "$IPA_PATH/iOS-AI-executor.ipa" ]; then
    IPA_SIZE=$(du -h "$IPA_PATH/iOS-AI-executor.ipa" | cut -f1)
    echo -e "${GREEN}✅ IPA Build Successful!${NC}"
    echo -e "${GREEN}   Location: $IPA_PATH/iOS-AI-executor.ipa${NC}"
    echo -e "${GREEN}   Size: $IPA_SIZE${NC}"
else
    echo -e "${YELLOW}⚠️  Note: Requires Xcode project setup${NC}"
fi

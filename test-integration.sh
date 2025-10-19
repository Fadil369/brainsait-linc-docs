#!/bin/bash
# BrainSAIT LINC Agent Integration Test Script
# Tests the complete ecosystem integration

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     BrainSAIT LINC Agent - Integration Test Suite             ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Verify LM Studio CLI
echo -e "${BLUE}[1/6]${NC} Testing LM Studio CLI..."
if command -v lms &> /dev/null; then
    echo -e "${GREEN}✓${NC} LM Studio CLI installed"
else
    echo -e "${YELLOW}⚠${NC} LM Studio CLI not found. Please install: curl -sSL https://lmstudio.ai/install.sh | bash"
    exit 1
fi

# Test 2: Check server status
echo -e "${BLUE}[2/6]${NC} Checking LM Studio server..."
lms status || echo -e "${YELLOW}⚠${NC} Server may not be running. Start with: lms server start"

# Test 3: Verify model availability
echo -e "${BLUE}[3/6]${NC} Checking BrainSAIT model..."
if lms ls | grep -q "brainsait-qwen3-8b"; then
    echo -e "${GREEN}✓${NC} BrainSAIT Qwen3-8B model found"
else
    echo -e "${YELLOW}⚠${NC} Model not found. Clone with: lms clone fadil369/brainsait-qwen3-8b"
fi

# Test 4: Verify preset availability
echo -e "${BLUE}[4/6]${NC} Checking LINC Agent preset..."
if [ -d "$HOME/.lmstudio/presets/fadil369/advanced-professional-background-instructions-for-brain-sait-linc-agents" ] || \
   [ -d "./advanced-professional-background-instructions-for-brain-sait-linc-agents" ]; then
    echo -e "${GREEN}✓${NC} LINC Agent preset found"
else
    echo -e "${YELLOW}⚠${NC} Preset not found. Clone with: lms clone fadil369/advanced-professional-background-instructions-for-brain-sait-linc-agents"
fi

# Test 5: Test API endpoint
echo -e "${BLUE}[5/6]${NC} Testing API endpoint..."
if curl -s http://localhost:1234/v1/models &> /dev/null; then
    echo -e "${GREEN}✓${NC} API endpoint responding"
else
    echo -e "${YELLOW}⚠${NC} API not accessible. Ensure server is running: lms server start"
fi

# Test 6: Sample healthcare query (if server is running)
echo -e "${BLUE}[6/6]${NC} Running healthcare integration test..."
if curl -s http://localhost:1234/v1/models &> /dev/null; then
    echo "Testing with sample FHIR query..."
    
    RESPONSE=$(curl -s -X POST http://localhost:1234/v1/chat/completions \
        -H "Content-Type: application/json" \
        -d '{
            "model": "fadil369/brainsait-qwen3-8b",
            "messages": [{"role": "user", "content": "What is FHIR R4?"}],
            "max_tokens": 100
        }' 2>&1)
    
    if echo "$RESPONSE" | grep -q "choices"; then
        echo -e "${GREEN}✓${NC} Healthcare query successful"
        echo "Sample response received from BrainSAIT LINC Agent"
    else
        echo -e "${YELLOW}⚠${NC} Could not complete test query. Make sure model is loaded."
    fi
else
    echo -e "${YELLOW}⚠${NC} Skipping query test (server not running)"
fi

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                  Integration Test Complete                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "1. Start server: lms server start"
echo "2. Load model: lms load fadil369/brainsait-qwen3-8b \\"
echo "              --preset=\"fadil369/advanced-professional-background-instructions-for-brain-sait-linc-agents\""
echo "3. Start chat: lms chat"
echo ""
echo "Example healthcare prompts:"
echo "• Create FHIR Patient for test patient"
echo "• What are ICD-10 codes for type 2 diabetes?"
echo "• Translate to Arabic: Take medication twice daily"
echo ""
echo "Documentation: https://github.com/Fadil369/brainsait-linc-docs"

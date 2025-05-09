#!/bin/bash
# WordNet DB Migrator Installation Script

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}WordNet DB Migrator Installation${NC}"
echo "=============================="

# Check Python version
echo "Checking Python version..."
if command -v python3 &>/dev/null; then
    PYTHON="python3"
elif command -v python &>/dev/null; then
    PYTHON="python"
else
    echo -e "${RED}Error: Python not found. Please install Python 3.6 or higher.${NC}"
    exit 1
fi

$PYTHON -c "import sys; sys.exit(0 if sys.version_info >= (3, 6) else 1)" || {
    echo -e "${RED}Error: Python 3.6 or higher is required.${NC}"
    echo "Current Python version:"
    $PYTHON --version
    exit 1
}

echo -e "${GREEN}✓ Python version OK${NC}"

# Check for venv module
$PYTHON -c "import venv" 2>/dev/null || {
    echo -e "${RED}Error: Python venv module not found.${NC}"
    echo "Please install the Python venv module."
    exit 1
}

# Check for PostgreSQL
echo "Checking PostgreSQL installation..."
if command -v psql &>/dev/null; then
    echo -e "${GREEN}✓ PostgreSQL installed${NC}"
    psql --version
else
    echo -e "${YELLOW}Warning: PostgreSQL command-line tools not found.${NC}"
    echo "Make sure PostgreSQL is installed and accessible."
fi

# Create virtual environment
echo "Creating virtual environment..."
if [ -d "wordnet_db_migrator_venv" ]; then
    echo -e "${YELLOW}Virtual environment already exists.${NC}"
else
    $PYTHON -m venv wordnet_db_migrator_venv || {
        echo -e "${RED}Error: Failed to create virtual environment.${NC}"
        exit 1
    }
    echo -e "${GREEN}✓ Virtual environment created${NC}"
fi

# Activate virtual environment
echo "Activating virtual environment..."
source wordnet_db_migrator_venv/bin/activate || {
    echo -e "${RED}Error: Failed to activate virtual environment.${NC}"
    exit 1
}

# Install dependencies
echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt || {
    echo -e "${RED}Error: Failed to install dependencies.${NC}"
    exit 1
}

# Install package in development mode
echo "Installing WordNet DB Migrator..."
pip install -e . || {
    echo -e "${RED}Error: Failed to install WordNet DB Migrator.${NC}"
    exit 1
}

echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo "To activate the virtual environment in the future, run:"
echo "source wordnet_db_migrator_venv/bin/activate"
echo ""
echo "To start WordNet DB Migrator, run:"
echo "python main.py"
echo ""
echo "For more information, see README.md"

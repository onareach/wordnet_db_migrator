# Implementation Plan for Database Path Configuration Improvements

## Phase 1: Code Modifications

### 1. Create a Configuration Management System

1. **Create a user configuration file**:
   - Add a function to create a config file in the user's home directory (e.g., `~/.wordnet_db_migrator/config.json`)
   - This file will store paths to the SQLite database and PostgreSQL connection details (excluding username and password)

2. **Implement configuration loading and saving**:
   - Add functions to load configuration from the file
   - Add functions to save/update configuration to the file
   - Handle cases where the config file doesn't exist yet

### 2. Update CLI Interface

1. **Add new command-line arguments**:
   - `--sqlite-path`: Path to the SQLite WordNet database
   - `--postgres-host`: PostgreSQL host
   - `--postgres-port`: PostgreSQL port
   - `--postgres-db`: PostgreSQL database name
   - Note: PostgreSQL username and password will always be prompted for, not stored in config

2. **Update the existing `--force` flag**:
   - Ensure it bypasses confirmation prompts for database paths
   - Note: Even with `--force`, PostgreSQL username and password will still be required

### 3. Implement Interactive Prompts

1. **First-run detection**:
   - Check if the config file exists
   - If not, trigger the first-run configuration workflow

2. **First-run configuration workflow**:
   - **SQLite database path**:
     - Prompt for SQLite database path
     - Validate the provided path
   
   - **PostgreSQL connection details**:
     - Look for PostgreSQL settings in PATH or environment variables
     - Show these detected settings to the user
     - Ask for confirmation or allow modification
     - Store only host, port, and database name (not username/password)
   
   - Save the configuration

3. **Subsequent-run confirmation workflow**:
   - Display the currently configured paths
   - Prompt for confirmation
   - If not confirmed, allow updating the paths
   - Skip if `--force` is used
   - Always prompt for PostgreSQL username and password

### 4. Update Main Execution Flow

1. **Modify the main execution flow**:
   - Check for command-line arguments first
   - If not provided, check for config file
   - If config file exists, load and (optionally) confirm
   - If no config file, run first-time setup
   - Always prompt for PostgreSQL username and password
   - Proceed with the migration process using the determined paths

## Phase 2: Testing

1. **Unit Tests**:
   - Write tests for the configuration management functions
   - Test loading, saving, and validating configurations
   - Test the command-line argument parsing
   - Test environment variable detection

2. **Integration Tests**:
   - Test the end-to-end workflow with different scenarios:
     - First-time run
     - Subsequent runs with confirmation
     - Using the `--force` flag
     - Providing paths via command-line arguments

3. **Manual Testing**:
   - Test on different operating systems
   - Test with different PostgreSQL setups
   - Test with different SQLite database locations

## Phase 3: GitHub Workflow Verification

1. **Update GitHub Actions Workflow**:
   - Modify the workflow to test the new configuration system
   - Add tests for different configuration scenarios
   - Ensure all tests pass before proceeding

2. **Run Local CI Tests**:
   - Use the local CI test script to verify the changes
   - Fix any issues that arise

## Phase 4: Documentation Updates

1. **Update README.md**:
   - Document the new command-line arguments
   - Explain the configuration system
   - Provide examples of different usage scenarios
   - Clearly state that PostgreSQL credentials are never stored

2. **Update CLI Help Text**:
   - Update the help text to include the new arguments
   - Provide clear descriptions of each argument

## Phase 5: Package Update on TestPyPI

1. **Update Version Number**:
   - Increment the version number in setup.py (e.g., from 0.1.0 to 0.2.0)

2. **Rebuild the Package**:
   ```bash
   source wordnet_db_migrator_venv/bin/activate
   cd wordnet_db_migrator
   rm -rf dist/*
   python -m build
   ```

3. **Upload to TestPyPI**:
   ```bash
   python -m twine upload --repository-url https://test.pypi.org/legacy/ --username __token__ --password YOUR_TEST_PYPI_TOKEN dist/*
   ```

4. **Test Installation from TestPyPI**:
   ```bash
   python -m venv test_env
   source test_env/bin/activate
   pip install --index-url https://test.pypi.org/simple/ --no-deps wordnet-db-migrator
   pip install psycopg2-binary pyyaml tqdm
   ```

5. **Verify the Updated Package**:
   - Test the new configuration system
   - Ensure all features work as expected

## Implementation Details

### Configuration File Structure

```json
{
  "sqlite": {
    "path": "/path/to/wn.db"
  },
  "postgres": {
    "host": "localhost",
    "port": 5432,
    "database": "wordnet"
    // Note: username and password are NOT stored
  },
  "last_confirmed": "2025-05-08T12:00:00Z"
}
```

### Environment Variable Detection

1. **PostgreSQL Environment Variables to Check**:
   - `PGHOST` or `POSTGRES_HOST`
   - `PGPORT` or `POSTGRES_PORT`
   - `PGDATABASE` or `POSTGRES_DB`
   - Note: We'll check for but not store `PGUSER`/`POSTGRES_USER` and `PGPASSWORD`/`POSTGRES_PASSWORD`

2. **Detection Process**:
   - Check common environment variables
   - Check for PostgreSQL configuration files (e.g., `.pg_service.conf`, `pg_hba.conf`)
   - Present found values to the user for confirmation

### Code Structure Changes

1. **New Module**: `wordnet_db_migrator/config.py`
   - Functions for managing configuration
   - Path resolution and validation
   - Environment variable detection

2. **Updates to**: `wordnet_db_migrator/cli.py`
   - New command-line arguments
   - Interactive prompts

3. **Updates to**: `wordnet_db_migrator/main.py`
   - Modified execution flow
   - Integration with configuration system
   - Always prompt for PostgreSQL credentials

This implementation plan provides a comprehensive approach to improving the user experience by making database paths more configurable, while maintaining security by never storing PostgreSQL credentials.

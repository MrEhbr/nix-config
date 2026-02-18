{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlit-tui";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Maxteabag";
    repo = "sqlit";
    tag = "v${version}";
    hash = "sha256-+7mv5aNJuNEudFARSZdB9/yedvqk6UHbfGku8J7Ye1g=";
  };

  build-system = with python3Packages; [
    hatch-vcs
    hatchling
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    docker
    duckdb
    keyring
    mariadb
    mysql-connector
    oracledb
    paramiko
    psycopg2
    pyodbc
    pyperclip
    sqlparse
    sshtunnel
    textual
    textual-fastdatatable
  ];

  pythonRelaxDeps = [
    "paramiko"
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sqlit" ];

  disabledTestPaths = [
    "tests/ui/"
  ];

  disabledTests = [
    "test_installer_cancel_terminates_process"
    "test_detect_strategy_pip_user_fallback"
  ];

  meta = {
    description = "Lightweight TUI for SQL Server, PostgreSQL, MySQL, SQLite, and more";
    homepage = "https://github.com/Maxteabag/sqlit";
    changelog = "https://github.com/Maxteabag/sqlit/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "sqlit";
  };
}
